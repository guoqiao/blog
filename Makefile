install:
	bundle install

build:
	bundle exec jekyll build

run:
	bundle exec jekyll serve --livereload

clean:
	bundle exec jekyll clean
