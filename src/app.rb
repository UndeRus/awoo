############################################
# => app.rb - Main Renderer
# => Awoo Textboard Engine
# => (c) prefetcher & github commiters 2017
#

require 'sinatra/base'
require 'sinatra/namespace'
require 'json'

require_relative 'routes/boards'
require_relative 'routes/api'
require_relative 'routes/errors'
require_relative 'routes/vichan_compat'
require_relative 'routes/thread_gc'


class Awoo < Sinatra::Base
  def initialize
    super
    @instance = self
  end
  def instance
    @instance
  end
  register Sinatra::Namespace
  register Sinatra::Awoo::Routing::Boards
  register Sinatra::Awoo::Routing::API
  register Sinatra::Awoo::Routing::Errors
  register Sinatra::Awoo::Routing::VichanCompat
  configure do
    set :bind, '0.0.0.0'
    set :port, config['port']
    set :awoo_version, '1.0.0'
    set :public_folder, File.dirname(__FILE__) + '/static'
    ThreadGC.prune!
  end
  set :root, File.dirname(__FILE__)
  enable :sessions
  before do
    headers "X-Powered-By" => "Awoo (https://github.com/dangeru/awoo)"
    headers "X-Loli-Provider" => "lolis.download"
  end
  get '/' do
    erb :index
  end
end
