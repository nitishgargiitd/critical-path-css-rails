module CriticalPathCss
  require 'critical_path_css/css_fetcher'

  CACHE_NAMESPACE = 'critical-path-css'

  def self.generate(route)
    Rails.cache.write(
      route,
      CssFetcher.new.fetch_route(route),
      namespace: CACHE_NAMESPACE,
      expires_in: nil
    )
  end
  
  def self.generate_for_controller_action(controller, action, route)
    Rails.cache.write(
      controller + "#" + action,
      CssFetcher.new.fetch_route(route),
      namespace: CACHE_NAMESPACE,
      expires_in: nil
    )
  end

  def self.generate_all
    CssFetcher.new.fetch.each do |route, css|
      Rails.cache.write(route, css, namespace: CACHE_NAMESPACE, expires_in: nil)
    end
  end

  def self.clear(route)
    Rails.cache.delete(route, namespace: CACHE_NAMESPACE)
  end

  def self.clear_matched(routes)
    Rails.cache.delete_matched(routes, namespace: CACHE_NAMESPACE)
  end

  def self.fetch(route)
    Rails.cache.read(route, namespace: CACHE_NAMESPACE) || ''
  end
  
  def self.fetch_for_controller_action(controller, action)
    Rails.cache.read(controller + "#" + action, namespace: CACHE_NAMESPACE) || ''
  end
end
