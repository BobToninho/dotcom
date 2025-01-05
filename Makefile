default:
	devd -l ./www/ \
    /values=www/values.html \
    /now=www/now.html \
    /note-taking=www/note-taking.html \
    /do-less=www/do-less.html

clean:
	rm -f www/GENERATED.html
