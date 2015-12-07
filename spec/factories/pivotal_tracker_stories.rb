FactoryGirl.define do
  factory :pivotal_tracker_story do
    sequence(:tracker_id) { |n| n + 1 }
    sequence(:name) { |n| "Fake story #{n}" }
    sequence(:pt_owner_ids) { [2222222, 3333333] }
    sequence(:state) { 'started' }
    sequence(:data) { |n| generate_data(n + 1) }
  end
end

def generate_data(n)
  [{
     'kind' => 'story',
     'id' => n,
     'created_at' => '2015-08-01T12:00:00Z',
     'updated_at' => '2015-08-01T13:00:00Z',
     'estimate' => 1,
     'story_type' => 'feature',
     'name' => 'Fake story',
     'description' => '',
     'current_state' => 'started',
     'requested_by_id' => 2222222,
     'project_id' => 123456,
     'url' => 'https://www.pivotaltracker.com/story/show/#{n}',
     'owner_ids' => [2222222, 3333333],
     'labels' => [],
     'owned_by_id' => 2222222
   }]
end
