# In your ENV, you need to export
# WIP_API_KEY
# WIP_PROJECT_NAME
# WIP_USER_ID

require "net/http"
require "uri"
require "json"

class WIP
  def initialize(api_key:)
    @api_key = api_key
  end

  def list_todos_by_user(user_id, completed)
    query = %{
      {
        user(id: #{user_id}) {
          id,
          username,
          todos(completed: #{completed}) {
            id,
            body,
            updated_at
          }
        }
      }
    }
    json = make_request query
    json["data"]["user"]["todos"]
  end

  def list_completed_todos_by_user(user_id)
    list_todos_by_user(user_id, true)
  end

  private

  def make_request(query)
    uri = URI.parse("https://wip.chat/graphql")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    header = {
      "Authorization": "bearer #{@api_key}",
      "Content-Type": "application/json"
    }
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = { query: query }.to_json

    # Send the request
    response = http.request(request)

    json = JSON.parse(response.body)
    if json.has_key? "errors"
      puts json["errors"]
      raise json["errors"].first["message"]
    end
    json
  end

  def serialize_attributes(attributes)
    attributes.collect do |k,v|
      "#{k}: \"#{v}\""
    end.join(", ")
  end
end

class TodoList
  def updated_at(todos, date)
    todos.select { |todo| todo["updated_at"].split("T").first == date }
  end

  def with_hashtag(todos, hashtag)
    todos.select { |todo| todo["body"].include? hashtag }
  end
end

today = Time.now.to_s.split(" ").first
wip = WIP.new(api_key: ENV["WIP_API_KEY"])
todo_list = TodoList.new

todos = wip.list_completed_todos_by_user(ENV["WIP_USER_ID"])
todays_todos = todo_list.updated_at(todos, today)

puts todo_list.with_hashtag(todays_todos, ENV["WIP_PROJECT_NAME"])
