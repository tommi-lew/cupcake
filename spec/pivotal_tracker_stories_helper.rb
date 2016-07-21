def fake_story_response_body(custom_values = {})
  {
    "kind" => "story",
    "id" => 111111111,
    "created_at" => "2015-08-01T12:00:00Z",
    "updated_at" => "2015-08-01T13:00:00Z",
    "estimate" => 1,
    "story_type" => "feature",
    "name" => "Fake story",
    "description" => "",
    "current_state" => "started",
    "requested_by_id" => 2222222,
    "project_id" => 123456,
    "url" => "https://www.pivotaltracker.com/story/show/111111111",
    "owner_ids" => [2222222, 3333333],
    "labels" => [],
    "owned_by_id" => 2222222
  }.merge(custom_values)
end

def fake_stories_response_body(custom_values = {})
  [fake_story_response_body.merge(custom_values)]
end

def fake_story_unfound_response_body
  {
    "code" => "unfound_resource",
    "kind" => "error",
    "error"=> "Some error message"
  }
end
