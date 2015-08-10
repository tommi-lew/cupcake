require 'rails_helper'

describe PivotalTrackerStory do
  it { should validate_presence_of :tracker_id }
  it { should validate_presence_of :name }
end
