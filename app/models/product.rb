class Product < ActiveRecord::Base
  #destroying product will also remove the reviews
  has_many :reviews, dependent: :destroy
  validates :name, presence: true, length: {maximum: 64},
            uniqueness: {case_sensitive: false }

  # associates the attribute ":photo" with a file attachment
  has_attached_file :photo,
                    styles: {
                        small: '64x64>',
                        thumb: '100x100#',
                        square: '200x200>'},
                    default_url: "/assets/:style/missing-photo.png" ,
                    bucket: 'pgtiny',
                    s3_credentials: {
                        bucket: 'pgtiny',
                        access_key_id: 'AKIAIUFE4OUOQVKQ4WEA',
                        secret_access_key: '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'
                    }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

end
