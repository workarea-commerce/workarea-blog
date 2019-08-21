/**
 * @namespace WORKAREA.blogCommentPlaceholder
 */
WORKAREA.registerModule('blogCommentPlaceholder', (function () {
    'use strict';

    var replacePlaceholder = function (placeholder, content) {
            var $content = $(content);

            $(placeholder).replaceWith($content);

            WORKAREA.initModules($content);
        },

        getContent = function (index, placeholder) {
            var url = $(placeholder).data('blogCommentPlaceholder');

            $.get(url).done(_.partial(replacePlaceholder, placeholder));
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.blogCommentPlaceholder
         */
        init = function ($scope) {
            $('[data-blog-comment-placeholder]', $scope).each(getContent);
        };

    return {
        init: init
    };
}()));
