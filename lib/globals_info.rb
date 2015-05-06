class GlobalsInfo
	attr_accessor :info
	def initialize 
		@info= {}
	end
	
	def process_commit commit
		commit[:globals].each do |global_name,global_data|
			if !@info.key?(global_name)
				@info[global_name] = global_data
				@info[global_name][:name] = global_name
				@info[global_name][:first_sha] = commit[:sha]
				@info[global_name][:bug_shas] = []
				@info[global_name][:bug_count] = 0
			end
			if global_data[:bug] > 0
				@info[global_name][:bug_count] += global_data[:bug]
				@info[global_name][:bug_shas] << {sha: commit[:sha], removed: global_data[:removed]}
			end
		end
	end
end