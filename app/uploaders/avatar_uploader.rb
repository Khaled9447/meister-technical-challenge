class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    '/images/default/avatar.jpg'
  end

  version :xlarge do
    process resize_to_fit: [1024, 1024]
  end

  version :large, from_version: :xlarge do
    process resize_to_fit: [512, 512]
  end

  version :medium, from_version: :large do
    process resize_to_fit: [300, 300]
  end

  version :small, from_version: :medium do
    process resize_to_fit: [150, 150]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg png)
  end
end
