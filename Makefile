default:
	devd -l ./www/ \
    /values=www/values.html \
    /now=www/now.html \
    /note-taking=www/note-taking.html \
    /do-less=www/do-less.html \
    /moving-out=www/moving-out.html \
    /focus=www/focus.html \
    /resolution=www/resolution.html \
    /haydar2013-report=www/haydar2013-report.html \
    /adoption=www/adoption.html

publish:
	rsync -avz www/* roberto@vps:/var/www/robertotonino.com/html/

# need to create a second file because inline-critical can't open and write the same file simultaneously
critical:
	bun x inline-critical --html www/adoption.html --css www/index.css > www/adoption2.html
	mv www/adoption2.html www/adoption.html

clean:
	rm -f www/GENERATED.html feed_REMOVE.html POST_TO_MOVE.html FEED_TO_MOVE.xml

.PHONY: default dev critical clean
