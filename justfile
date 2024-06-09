default:
  devd -l ./www/ \
    /values=http://devd.io:8000/values.html \
    /now=http://devd.io:8000/now.html
