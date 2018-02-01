			require "uri"
			require "net/http"
			require 'json'
			require 'pry'
			require 'dotenv/load'
			require 'platform-api'


			class CodeController < ApplicationController
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

			  	end
				

				def submitcode
					@ret_view =13
					
					# Send the Post request
					uri = URI("http://0fa75163.compilers.sphere-engine.com/api/v3/submissions?access_token=6bf3291fc2e34e712d804efe8a198e11")
					uri.query = URI.encode_www_form({"access_token" => "6bf3291fc2e34e712d804efe8a198e11" })
			 		response = Net::HTTP.post_form(uri, {'sourceCode' => params["sc"] , 'compilerId' => params["Compiler"], 'input' => params["testcase"]})
			 		
			 			
			 		returned_id=JSON.parse(response.body)["id"].to_s
					returned_status=-1	
					 		
					 				
					p returned_id
					

					
					# url = URI.parse("http://0fa75163.compilers.sphere-engine.com/api/v3/submissions/"+returned_id+"?access_token=6bf3291fc2e34e712d804efe8a198e11")
					# req = Net::HTTP::Get.new(url.to_s)
					# url.query = URI.encode_www_form({  "access_token" => "6bf3291fc2e34e712d804efe8a198e11" ,
					# 									"withSource" => "true", 
					# 				                    "withInput" => "true", 
					# 				                    "withOutput" => "true" ,
					# 				                    "withStderr" => "true",
					# 				                    "withCmpinfo" => "true"
					# 				                })


					params =  {"access_token" => "6bf3291fc2e34e712d804efe8a198e11" ,
															"withSource" => "true", 
										                    "withInput" => "true", 
									    	                "withOutput" => "true" ,
									        	            "withStderr" => "true",
					 				            	        "withCmpinfo" => "true"
						       }
						uri = URI("http://0fa75163.compilers.sphere-engine.com/api/v3/submissions/"+returned_id+"?access_token=6bf3291fc2e34e712d804efe8a198e11")
						#
						uri.query = URI.encode_www_form(params)
						res = Net::HTTP.get_response(uri)
						puts "Access Token: "+res.body
					

					render plain: res.body
					#out= JSON.parse Net::HTTP.get_response(url).body
					out=res 
					p "output is "
					p out
					returned_status = out["status"]
					returned_result = out["result"]	
					p "returned is :->"
					p "returned_status: "+out["status"].to_s
					p "returned_result: "+out["result"].to_s
					@ret_view = out["output"]
						
					puts out["output"]

						

						if out["result"] == 15
						    render plain:  @ret_view					
						elsif out["result"] == 11
							render plain: "Compilation Error"
						elsif out["result"] == 12
							render plain: "Runtime Error"
						elsif out["result"] == 13
							render plain: "Time Limit Exceeded"		
						elsif out["result"] == 17
							render plain: "Memory Limit Exceeded"	
						elsif out["result"] == 19
							render plain: "Illegal System Call"	
						elsif out["result"] == 20
							render plain: "Internal Error	"	
					end  
					   	
				end

			end