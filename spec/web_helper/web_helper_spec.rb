require_relative '../../lib/web_helper'
require 'rspec'
require 'webmock/rspec'

describe WebHelper do
  RSpec::Matchers.define_negated_matcher :not_have_requested, :have_requested

	let(:url) { "http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=1WHNSFSC9ND0X52YFRAT&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_1" }
  let(:url2) { "http://www.imdb.com/title/tt0111161?pf_rd_m=A2FGELUUNOQJNL&" }
  let(:file_name) { WebHelper.get_name_for(url) }
  let(:file_contents) { File.read(file_name) }

  describe '#url_to_filename' do
    it { expect(WebHelper.url_to_filename(url)).to eq('title_tt0111161.html') }
    it { expect(WebHelper.url_to_filename(url2)).to eq('title_tt0111161.html') }
  end

  describe '#cashed_get' do
    before(:example) do
      stub_request(:get, url)
    end

    context 'when no file' do
      before(:example) do
        File.delete(file_name) if File.exists?(file_name)
      end

      it { expect(WebHelper.cashed_get(url)).to eq(file_contents).and have_requested(:get, url) }
    end

    context 'when file exists' do
      after(:example) do
        File.delete(file_name) if File.exists?(file_name)
      end

      it { expect(WebHelper.cashed_get(url)).to not_have_requested(:get, url).and eq(file_contents) }
    end
  end

end