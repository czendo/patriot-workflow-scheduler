require 'init_test'
require 'rest_client'

describe  Patriot::Worker::InfoServer do
  
  context "default config" do
    before :all do 
      @config = config_for_test('worker')
      port = @config.get(Patriot::Worker::InfoServer::PORT_KEY,
                         Patriot::Worker::InfoServer::DEFAULT_PORT)
      @url = "http://127.0.0.1:#{port}"
      @worker = Patriot::Worker::MultiNodeWorker.new(@config)
      @job1 = TestEnvirionment.build_job()
      @job2 = TestEnvirionment.build_job()
      @job_store = @worker.instance_variable_get(:@job_store)
      @update_id = Time.now.to_i
      @job_store.register(@update_id, [@job1,@job2])
      @worker.instance_variable_set(:@status, Patriot::Worker::Status::ACTIVE)
      @info_server = @worker.instance_variable_get(:@info_server)
      @info_server.start_server
      sleep 1
    end

    after :all do
      @info_server.shutdown_server
    end

    describe "status" do
      it "should return status" do
        expect(RestClient.get("#{@url}/worker")).to match Patriot::Worker::Status::ACTIVE
        @worker.instance_variable_set(:@status, Patriot::Worker::Status::SLEEP)
        expect(RestClient.get("#{@url}/worker")).to match Patriot::Worker::Status::SLEEP
      end
    end

    describe "job" do
      it "should return job status" do
        job_status = RestClient.get("#{@url}/jobs/#{@job1.job_id}", :accept => :json)
        json = JSON.parse(job_status)
        expect(json["job_id"]).to eq @job1.job_id
        expect(json["state"]).to eq Patriot::JobStore::JobState::WAIT
      end
    end

  end

  context "another config" do
    before :all do 
      @config = config_for_test('worker', 'test.infoserver')
      port = @config.get(Patriot::Worker::InfoServer::PORT_KEY)
      @url = "http://127.0.0.1:#{port}"
      @worker = Patriot::Worker::MultiNodeWorker.new(@config)
      @job1 = TestEnvirionment.build_job()
      @job2 = TestEnvirionment.build_job()
      @job_store = @worker.instance_variable_get(:@job_store)
      @update_id = Time.now.to_i
      @job_store.register(@update_id, [@job1,@job2])
      @worker.instance_variable_set(:@status, Patriot::Worker::Status::ACTIVE)
      @info_server = @worker.instance_variable_get(:@info_server)
      @info_server.start_server
      sleep 1
    end

    after :all do
      @info_server.shutdown_server
    end

    describe "status" do
      it "should return status" do
        expect(RestClient.get("#{@url}/w")).to match Patriot::Worker::Status::ACTIVE
        @worker.instance_variable_set(:@status, Patriot::Worker::Status::SLEEP)
        expect(RestClient.get("#{@url}/w")).to match Patriot::Worker::Status::SLEEP
      end
    end

    describe "job" do
      it "should return job status" do
        job_status = RestClient.get("#{@url}/j/#{@job1.job_id}", :accept => :json)
        json = JSON.parse(job_status)
        expect(json["job_id"]).to eq @job1.job_id
        expect(json["state"]).to eq Patriot::JobStore::JobState::WAIT
      end
    end

  end

end
