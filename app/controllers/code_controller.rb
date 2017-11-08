require "uri"
require "net/http"
require 'json'
require 'pry'
require 'dotenv/load'



class CodeController < ApplicationController
	
	at=ENV['personal_key']
	# GET REQUEST FOR COMPILERS NAME AND ID 
	def execute
		url = URI.parse("http://0fa75163.compilers.sphere-engine.com/api/v3/compilers?access_token=" + ENV['personal_key'])
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) { 
							|http|  http.request(req)
						}
		arr = JSON.parse(res.body)["items"]

		@language_array = []
		
		arr.each do |i|
			@language_array << [ i["name"],i["id"] ]
		end  

  	end



	

	def submitcode
		@ret_view = nil
		

	
	

		# Send the Post request
		uri = URI('http://0fa75163.compilers.sphere-engine.com/api/v3/submissions?access_token='+ENV['personal_key'])
		uri.query = URI.encode_www_form({"access_token" => ENV['personal_key'] })
 		response = Net::HTTP.post_form(uri, {'sourceCode' => params["sc"] , 'compilerId' => params["Compiler"], 'input' => params["testcase"]})
 		
 		returned_id=JSON.parse(response.body)["id"]
					returned_status=-1
					

					sleep(5)
					
							url = URI.parse('http://0fa75163.compilers.sphere-engine.com/api/v3/submissions/'+returned_id+'?access_token=6bf3291fc2e34e712d804efe8a198e11')
							req = Net::HTTP::Get.new(url.to_s)
							url.query = URI.encode_www_form({  "access_token" => ENV['personal_key'] ,
															   "withSource" => true, 
						                                       "withInput" => true, 
						                                       "withOutput" => true ,
						                                       "withStderr" => true,
						                                       "withCmpinfo" => true
						                                    })
     						out= JSON.parse Net::HTTP.get_response(url).body
						
					
							#PRINT RESPONSE  res.body	
							#out = JSON.parse(res.body)
							returned_status = out["status"]
							returned_result = out["result"]	
					@ret_view = out["output"]

			 if out["result"] == 15
			 render plain:  @ret_view					
		   	end  
		   
		
			
			
														
#	binding.pry
	end
	
	

end


