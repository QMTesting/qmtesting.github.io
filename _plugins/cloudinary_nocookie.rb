module CloudinaryNoCookie
  def nocookie(input)
    input.gsub("https://res.cloudinary.com", "https://res.cloudinary.com")
  end
end

Liquid::Template.register_filter(CloudinaryNoCookie)
