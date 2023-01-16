class JobsController < ApplicationController
  before_action :set_job, only: %i[destroy ]

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # POST /jobs or /jobs.json
  def create
    @job = Job.new(job_params)
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy
  end

  private

  # Only allow a list of trusted parameters through.
  def job_params
    params.fetch(:job, {})
  end
end
