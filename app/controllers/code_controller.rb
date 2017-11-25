 require "uri"
require "net/http"
require 'json'
require 'pry'
require 'dotenv/load'



class CodeController < ApplicationController
	
	at=ENV['personal_key']
	# GET REQUEST FOR COMPILERS NAME AND ID 
	def execute
		url = URI.parse("http://0fa75163.compilers.sphere-engine.com/api/v3/compilers?access_token=6bf3291fc2e34e712d804efe8a198e11")
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) { 
							|http|  http.request(req)
						} 
		arr = JSON.parse(res.body)["items"]

		@language_array = []
		
		arr.each do |i|
			@language_array << [ i["name"],i["id"] ]
		end  

		#arr.each do |i|
		#@language_array << [ i["name"],i["id"] ]
		#end if arr

  	end



	

	def submitcode
		@ret_view =13
		
		# Send the Post request
		uri = URI("http://0fa75163.compilers.sphere-engine.com/api/v3/submissions?access_token=6bf3291fc2e34e712d804efe8a198e11")
		uri.query = URI.encode_www_form({"access_token" => ENV['personal_key'] })
 		response = Net::HTTP.post_form(uri, {'sourceCode' => params["sc"] , 'compilerId' => params["Compiler"], 'input' => params["testcase"]})
 		
 			print "here0" 		returned_id=JSON.parse(response.body)["id"].to_s
					returned_status=-1	
		 		
		 				
					
							url = URI.parse("http://0fa75163.compilers.sphere-engine.com/api/v3/submissions/"+returned_id+"?access_token=6bf3291fc2e34e712d804efe8a198e11")
							req = Net::HTTP::Get.new(url.to_s)
							url.query = URI.encode_www_form({  "access_token" => "6bf3291fc2e34e712d804efe8a198e11" ,
															   "withSource" => true, 
						                                       "withInput" => true, 
						                                       "withOutput" => true ,
						                                       "withStderr" => true,
						                                       "withCmpinfo" => true
						                                    })
							loop do 
						  	sleep(1)
						    if Net::HTTP.get_response(url).body != nil
				 			   break
								  end
							end
							print "here1"
     						out= JSON.parse Net::HTTP.get_response(url).body
							print "here2"
					
							#PRINT RESPONSE  res.body	
							#out = JSON.parse(res.body)
							returned_status = out["status"]
							returned_result = out["result"]	
					@ret_view = out["output"]
					print "here3"
			 if out["result"] == 15
			# ERB.render("submitcode.html.erb",submitcode.instance_variables)
			# render plain:  @ret_view					
		   		print "main here"
		   		render "submitcode"
		   	end  
		   	
		
		   print "here5"
		
			
			
														
#	binding.pry
	end
	
	

end


