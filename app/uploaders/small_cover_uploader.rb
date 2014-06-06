class SmallCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

#  process :resize_to_fill => [166, 236]

  def store_dir
    if Rails.env.test?
      "uploads/testing"
    else
      "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
    end
  end
end