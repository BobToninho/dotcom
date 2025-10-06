default:
	rsync -avz www/* roberto@vps:/var/www/robertotonino.com/html/

dev:
	devd -l ./www/ \
    /values=www/values.html \
    /now=www/now.html \
    /note-taking=www/note-taking.html \
    /do-less=www/do-less.html \
    /moving-out=www/moving-out.html \
    /focus=www/focus.html \
    /haydar2013-report=www/haydar2013-report.html \
    /adoption=www/adoption.html

critical:
	# bun x inline-critical --html www/index.html --css www/index.css > www/index2.html
	# mv www/index2.html www/index.html
	bun x inline-critical --html www/adoption.html --css www/index.css > www/adoption2.html
	mv www/adoption2.html www/adoption.html

clean:
	rm -f www/GENERATED.html feed_REMOVE.html POST_TO_MOVE.html FEED_TO_MOVE.xml

.PHONY: default critical clean
