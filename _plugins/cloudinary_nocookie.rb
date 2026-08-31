module CloudinaryNoCookie
  def nocookie(input)
    input.gsub("https://no-cookie.cloudinary.com", "https://no-cookie.cloudinary.com")
  end
end

Liquid::Template.register_filter(CloudinaryNoCookie)
