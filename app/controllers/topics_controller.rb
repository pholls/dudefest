class TopicsController < ApplicationController
  def show
    @topic = Topic.find_by topic: params[:id].sub('+', ' ')
    @articles = Article.public_articles.select { |a| a.topic == @topic }
    @header = 'ON THE SUBJECT OF ' + @topic.topic.upcase
  end
end
