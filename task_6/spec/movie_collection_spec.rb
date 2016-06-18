require_relative '../netfix'
require 'csv'

RSpec::Matchers.define :include_in_attribute do |key, expected|
  match do |actual|
    actual.send(key).include?(expected)
  end
end

describe MovieCollection do

  let(:movie_collection) {MovieCollection.read}

  it { expect(movie_collection).to be_instance_of MovieCollection}

  describe '#films_by_producers' do
    subject {movie_collection.films_by_producers}
    it { is_expected.to be_instance_of Hash}
    it { is_expected.to all(be_instance_of Array)}
  end

  describe '#filter' do

    let(:filter) { {year: 1994, country: 'USA'} }
    let(:bad_filter) { {genre: 'Tragedy'} }

    it { expect{movie_collection.filter(bad_filter)}.to raise_error(ArgumentError, "No movies found with filter #{bad_filter}") }  	
  	it { expect(movie_collection.filter(filter).collection).to all have_attributes(:year => 1994, :country => 'USA') }

    let(:filtered_collection) {movie_collection.filter(actors: 'Sharon Stone').collection}
    it {expect(filtered_collection).to all(include_in_attribute(:actors, 'Sharon Stone'))}
    it {expect(filtered_collection.length).to eq(1)}
  end


end