title: curl notes

get web page source code:

    curl www.google.com

get and save this web page:

    curl -o google.html www.google.com

this is the same as wget.

some domain will auto redirect, for example, google.com will redirect to google.co.nz if you are in nz. To allow auto redirect:

    curl -L www.google.com

show header info with web page source code:

    curl -i www.google.com

header only:

    curl -I www.google.com

show connection steps:

    curl -v www.google.com

even more info:

    curl --trace output.txt www.google.com

the above one will show hex data, to show ascii only:

    curl --trace-ascii output.txt www.google.com

send get data:

    curl example.com/form.cgi?data=xxx

send post data:

    curl -X POST --data "data=xxx" example.com/form.cgi

the default method is GET, use -X to specify other ones:

    curl -X DELETE www.example.com
