# spec/requests/api/v1/listings_spec.rb
require 'spec_helper'
require 'support/vcr_setup'

describe 'Listings API' do
  it 'sends a list of listings' do
    VCR.use_cassette('listings/listings') do
      get '/api/v1/listings.json'
    end

    json = JSON.parse(response.body)

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the right amount of listings are returned
    # (based on VCR cassette with 5 listings)
    expect(json['listings'].length).to eq(5)
  end

  it 'sends an individual listing' do
    VCR.use_cassette('listings/a0X210000004afdEAA') do
      get '/api/v1/listings/a0X210000004afdEAA.json'
    end

    json = JSON.parse(response.body)

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the right Id is present
    expect(json['listing']['Id']).to eq('a0X210000004afdEAA')
  end

  it 'gets eligibility matches' do
    VCR.use_cassette('listings/eligibility') do
      params = {
        eligibility: {
          householdsize: 2,
          incomelevel: 20_000,
          childrenUnder6: 1,
        },
      }
      post '/api/v1/listings-eligibility.json', params
    end

    json = JSON.parse(response.body)

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the Eligibility_Match param is present
    expect(json['listings'].first['Does_Match']).not_to be_nil
  end
end
