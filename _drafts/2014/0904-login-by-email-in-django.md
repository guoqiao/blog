Title: 在 Django 中实现用 email 登录

## 问题描述
Django 默认是通过 username 登录. 而在实际的项目中,  往往通过 email 登录更合理. 

Django 1.5 以后, 提供了自定义 AUTH_USER_MODEL 的方法. 理论上, 你可以自定义 User 来实现 email 登录. 不过, 在实际使用中我发现, User 是 Django 框架中最核心的 Model, 一旦自定义, 会带来一系列问题. 

例如在 Admin 里管理 User 时, 密码居然是直接显示的, 新建 User 也是明文密码. 你需要自定义 Admin 里 User 相关的一系列表单.

又比如, 在代码里引用 User 时, 你不能再使用

    from django.contrib.auth.models import User
    
而要写

    from django.contrib.auth import get_user_model
    User = get_user_model()
    
以及

    user = models.ForeignKey(settings.AUTH_USER_MODEL)
    
看着别扭, 写起来啰嗦不说, 很多第三方代码依然是使用旧的方式引用 User, 一跑就出错.然后 South 也会频繁的报错. 总之是体验很不好. 其实完全可以在保留内置 User 的前提下, 通过自定义一个 backend 来实现. 当然, 相关的表单和 view 也需要简单修改下. 至于 User 字段的扩展, 还是可以通过 Profile 的方式来实现.

## 自定义 backend

假如你的 Django 项目中帐号相关的 app 叫 accounts. 在这个 app 里新建一个 backends.py 文件, 内容如下:

    from django.contrib.auth.models import User
    
    class EmailAuthBackend(object):
        """
        Email Authentication Backend
        
        Allows a user to sign in using an email/password pair rather than
        a username/password pair.
        """
        
        def authenticate(self, email=None, password=None):
            """ Authenticate a user based on email address as the user name. """
            try:
                user = User.objects.get(email=email)
                if user.check_password(password):
                    return user
            except User.DoesNotExist:
                return None 
    
        def get_user(self, user_id):
            """ Get a User object from the user_id. """
            try:
                return User.objects.get(pk=user_id)
            except User.DoesNotExist:
                return None

然后, 在你的 settings 模块中增加如下配置:

    AUTHENTICATION_BACKENDS = (
        'accounts.backends.EmailAuthBackend',
        'django.contrib.auth.backends.ModelBackend',
    )
      

以上是 Django 的 auth backend 的标准写法. 注意 authenticate 方法传入的参数是 email 而不是 username, 查找用户也是通过 email 来 get, 而不是通过 username, 这样就实现了通过 email 登录的后端代码. 

看到 get 方法你可能很快想到一个问题: email 不唯一怎么办? 确实, 在 Django 的 User 定义中, username 是 unique = True 的, 而 email 则没有要求. 你需要在注册时通过代码控制 email 的唯一性.

## 登录代码
假如你的 LoginForm 定义如下: 

    class LoginForm(forms.Form):
         email = forms.EmailField()
         password = forms.CharField(widget=forms.PasswordInput)
         
    def clean_email():
        ## TODO: validate email, raise error if not existing or duplicated.
   
然后是 login view:

    from django.contrib.auth import authenticate
    from django.contrib.auth import login as auth_login

    def login(request):
        F = LoginForm
        if request.method == 'GET':
            form = F()
        else:
            form = F(data=request.POST)
            if form.is_valid():
                email = form.cleaned_data['email']
                password = form.cleaned_data['password']
                user = authenticate(email=email, password=password)
                if user and user.is_active:
                    auth_login(request,user)
                    return redirect('home')
        ctx = {'form': form}
        return render(request, 'accounts/login.html', ctx)
      
其实和 Django 内置 login 方法主要的不同也就是传递给 authenticate 方法的参数不同.

## 注册代码

参考了下内置的注册表单, 修改后的SignupForm版本如下

    class SignupForm(forms.ModelForm):
    
        error_messages = {
            'duplicate_username': _("A user with that username already exists."),
            'password_mismatch': _("The two password fields didn't match."),
            'email_exists': _("Email address already exists."),
        }
    
        email = forms.EmailField(label="Email Address")
        password1 = forms.CharField(label="New Password", widget=forms.PasswordInput)
        password2 = forms.CharField(label="Confirm Password", widget=forms.PasswordInput)
    
        class Meta:
            model = User
    
        def clean_email(self):
            email = self.cleaned_data.get("email")
            if email and User.objects.filter(email=email):
                raise forms.ValidationError(
                    self.error_messages['email_exists'],
                    code='email_exists',
                )
            return email
    
        def clean_password2(self):
            password1 = self.cleaned_data.get("password1")
            password2 = self.cleaned_data.get("password2")
            if password1 and password2 and password1 != password2:
                raise forms.ValidationError(
                    self.error_messages['password_mismatch'],
                    code='password_mismatch',
                )
            return password2
    
        def save(self, commit=True):
            user = super(SignupForm, self).save(commit=False)
            data = self.cleaned_data
            user.username = data['email'] # use email as username also
            user.set_password(data['password1'])
            if commit:
                user.save()
                #save user profile if necessary
                #p = user.profile
                #p.address = data['address']
                p.save()
            return user

此处的重点是 save , 有几个细节要注意:

* 还是需要生成唯一的 username 供 Django 使用. 这里我为方便, 直接使用 email 作为 username. 
* 密码需要使用 user.set_password 加密后再保存.
* 如果你定义了 profile, 在此处需要一起生成并保存.

至于 view, 就是标准的表单处理代码, 没有什么特别的了. 例如我的代码片段如下:

    @render_to(T('signup'))
    def signup(request):
        F = f.SignupForm
        if request.method == 'GET':
            form = F()
        else:
            form = F(data=request.POST)
            if form.is_valid():
                form.save()
                return redirect('home')
        ctx = {'form': form}
        return ctx

到这里, 你已经可以使用 email 登录了. 