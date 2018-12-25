require "open-uri"

module Spree
	Image.class_eval  do
		# validates :check_attachment_presence, :presence => true
		# validates_attachment.reject!
		# _validators.reject!{ |key, _| key == :attachment }

				 
		#   _validate_callbacks.reject do |callback|
		#     callback.raw_filter.attributes == [:attachment]
		#   end


		def picture_from_url(url)
          self.attachment = open(url)
        end
	end
end

