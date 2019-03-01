// write js function override for product.js here

Spree.ready(function ($) {

    Spree.showVariantImages = function (imageIds) {
        ($('li.vtmb')).hide();
        for (let i = 0; i < imageIds.length; ++i) {
            ($('li.tmb-' + imageIds[i])).show()
        }
        var currentThumb = $('#' + ($('#main-image')).data('selectedThumbId'))

        if (!currentThumb.hasClass('vtmb + varianftId')) {
            var thumb = $(($('#product-images ul.thumbnails li:visible.vtmb')).eq(0))

            if (!(thumb.length > 0)) {
                thumb = $(($('#product-images ul.thumbnails li:visible')).eq(0))
            }

            var newImg = thumb.find('a').attr('href')

            var newAlt = thumb.find('img').attr('alt');
            ($('#product-images ul.thumbnails li')).removeClass('selected')
            thumb.addClass('selected');
            ($('#main-image img')).attr({ 'src': newImg, 'alt': newAlt });
            ($('#main-image')).data({ 'selectedThumb': newImg, 'selectedThumbAlt': newAlt })
            return ($('#main-image')).data('selectedThumbId', thumb.attr('id'))
        }
    }
})