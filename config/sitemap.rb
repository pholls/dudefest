# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'http://www.dudefest.com'
SitemapGenerator::Sitemap.sitemaps_host = 'http://s3.amazonaws.com/sitemap-generator/'
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

SitemapGenerator::Sitemap.create do
  add '/about', changefreq: 'monthly'
  add '/contribute', changefreq: 'monthly'
  add '/coming_soon', changefreq: 'monthly'
  add '/movies', changefreq: 'daily'
  add '/guyde', changefreq: 'daily'
  add '/booze', changefreq: 'daily'
  add '/frat', changefreq: 'daily'
  Article.find_each do |article|
    add article_path(article), lastmod: article.updated_at if article.public?
  end
end
