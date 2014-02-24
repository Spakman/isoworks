module PhotoHelpers
  def small_photo_url(photo)
    "/photos/small/#{photo.filename}"
  end
end
