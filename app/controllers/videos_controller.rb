class VideosController < ApplicationController
	def get_videos
		r_videos = Video.where(email: params[:email], source: params[:source]).to_a
		render json: r_videos
	end
	def create
		video = Video.new(video_params)
		if video.save
			render json: video, status: :created
		else
			render json: video.errors, status: :unprocessable_entry
		end
	end

	private

		def video_params
			params.permit(:stream_id, :stream_name, :email, :url, :source)
		end
end