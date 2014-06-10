class TopicsController < ApplicationController
  def show
    @topic = Topic.find_by topic: params[:id].gsub('+', ' ')
    @articles = Article.public_articles.select { |a| a.topic == @topic }
    @all_articles = Article.public.first(10)
    @header = 'ON THE SUBJECT OF ' + @topic.topic.upcase
  end
end
