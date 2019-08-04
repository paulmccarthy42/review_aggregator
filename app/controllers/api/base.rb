module API
  class Base < Grape::API
    mount API::V1::Reviews
  end
end