
(function(){

    var module = {};
    window.helper = module;

    var fn = {}

    fn.empty = function(el) {
        while (el.firstChild) {
            el.removeChild(el.firstChild)
        }
        return el;
    };

    fn.replaceInner = function(id, el) {
        fn.empty(document.getElementById(id))
            .appendChild(el);
    };

    fn.traverseTree = function(startNode, visitor) {
        visitor.start(startNode);            
        for (var i = 0; i < startNode.childNodes.length; i++) {
            this.traverseTree(startNode.childNodes[i], visitor);
        }
        visitor.end(startNode);
    };

    fn.convertSVGtoDataUri = function(src) {
        var xml = new XMLSerializer().serializeToString(src);
        return 'data:image/svg+xml;base64,' + btoa(xml);
    };

    fn.createInlineSVG = function(svg, callbackWithResult) {

        var loaderQueue = [],

            loadNext = function(callback) {
                if (loaderQueue.length == 0) {
                    callback();
                    return;
                }
                var loader = document.createElement('iframe'),
                    next = loaderQueue.pop()
                    from = next.from,
                    to = next.to;
                loader.onload = function() {
                    var svg = loader.contentDocument.firstChild,
                        loadedNode;
                    svg.childNodes.forEach(function(el) {
                        loadedNode = el.cloneNode(true);
                        to.parentNode.insertBefore(loadedNode, to);
                    });
                    to.parentNode.removeChild(to);
                    loadNext(callback);
                };
                loader.setAttribute('class', 'hidden');
                loader.setAttribute('src', from);
                document.body.appendChild(loader);
            },

            visitor = {
                _node: null,
                _nodes: [], 
                start: function(node) {
                    var newNode = node.cloneNode(false);
                    newNode.setAttribute('id', undefined);
                    if (this._node !== null) {
                        this._node.appendChild(newNode);
                        this._nodes.push(this._node);
                    } else {
                        this._nodes.push(newNode);
                    }
                    if (node.tagName === 'image') {
                        var url = node.getAttribute('xlink:href');
                        loaderQueue.push({from: url, to: newNode});
                    }
                    this._node = newNode;
                },
                end: function(node) {
                    this._node = this._nodes.pop();
                }
            };

        fn.traverseTree(svg, visitor);

        loadNext(function() {
            callbackWithResult(visitor._node);
        });
    }

    fn.onSave = function(callback) {

        var preview = document.getElementById('preview');

        fn.createInlineSVG(preview, function(svg) {

            var img = document.createElement('img'),
                canvas = document.createElement('canvas');

            canvas.setAttribute('width', '240');
            canvas.setAttribute('height', '240');

            img.setAttribute('src', fn.convertSVGtoDataUri(svg));
            img.onload = function() {
                canvas.getContext('2d')
                    .drawImage(img, 0, 0);
            }

            fn.replaceInner('save_as_svg', img);
            fn.replaceInner('save_as_png', canvas);

            callback('success');
        });
    }    
    
    module.save = function(event, callback) {    
        fn.onSave(callback);
    }

})()