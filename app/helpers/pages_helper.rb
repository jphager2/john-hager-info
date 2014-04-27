module PagesHelper
  def load_github_activity 
    @events = JSON(
      open('https://api.github.com/users/jphager2/events/public').read
    )[0..4] 
  end
end

