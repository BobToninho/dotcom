default:
	devd -l ./www/ \
    /values=www/values.html \
    /now=www/now.html \
    /note-taking=www/note-taking.html \
    /do-less=www/do-less.html \
    /moving-out=www/moving-out.html \
    /focus=www/focus.html \
    /haydar2013-report=www/haydar2013-report.html

clean:
	rm -f www/GENERATED.html feed_REMOVE.html
