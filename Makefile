all:
	nave use stable coffee -c img2css.coffee
	haml -qf html5 index.haml index.html
