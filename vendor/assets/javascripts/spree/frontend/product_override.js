// write js function override for product.js here

Spree.ready(function ($) {
    // Handle select variant by click option value
    var option_value_ids = []
    var sizeId = -1
    var colorId = -1

    // make the first variant select at default
    $(window).on('load', function () {
            if (!(typeof option_size_id === 'undefined')) {
                sizeId = option_size_id
                alert(sizeId)
                $(".size-option #" + sizeId).addClass("active");
            }
            if (!(typeof option_color_id === 'undefined')) {
                colorId = option_color_id
                alert(colorId)
                $(".size-option #" + colorId).addClass("active");
            }
            Spree.showVariantImages(JSON.parse(default_variant_image_ids))
        }
    );

    function getVariantByAjax() {
        $.ajax({
            url: '/products/' + product_id + '/get_variant?ids=' + option_value_ids.join(','),
            method: "post",
            success: function (data) {
                option_value_ids = []
                Spree.showVariantImages(data.image_ids)
                document.getElementById('hidden-variant-id').value = data.variant_id;
                alert(document.getElementById('hidden-variant-id').value)
            }
        });
    }

    $('.size > li').click(function () {
            // If this isn't already active
            if (!$(this).hasClass("active")) {
                // Remove the class from anything that is active
                $(".size > li.active").removeClass("active");
                // And make this active
                $(this).addClass("active");

                // get and add option_value_id to option_value_ids array
                sizeId = $(this).attr('id')

                var hasBothType = $(".product-options .variant-options").length == 2

                if (hasBothType) {
                    if (sizeId != -1 && colorId != -1) {
                        option_value_ids.push(sizeId)
                        option_value_ids.push(colorId)
                        getVariantByAjax()
                    }
                } else {
                    option_value_ids.push(sizeId)
                    getVariantByAjax()
                }
            }
        }
    );

    $('.color > li').click(function () {
            // If this isn't already active
            if (!$(this).hasClass("active")) {
                // Remove the class from anything that is active
                $(".color > li.active").removeClass("active");
                // And make this active
                $(this).addClass("active");

                // get and add option_value_id to option_value_ids array
                colorId = $(this).attr('id')

                var hasBothType = $(".product-options .variant-options").length == 2

                if (hasBothType) {
                    if (sizeId != -1 && colorId != -1) {
                        option_value_ids.push(sizeId)
                        option_value_ids.push(colorId)
                        getVariantByAjax()
                    }
                } else {
                    option_value_ids.push(colorId)
                    getVariantByAjax()
                }
            }
        }
    );

    // override this function from spree js
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
            ($('#main-image img')).attr({'src': newImg, 'alt': newAlt});
            ($('#main-image')).data({'selectedThumb': newImg, 'selectedThumbAlt': newAlt})
            return ($('#main-image')).data('selectedThumbId', thumb.attr('id'))
        }
    }
})

// will write a general function that cover all type click for jquery, now it just for color and size, cause the store only have color and size




