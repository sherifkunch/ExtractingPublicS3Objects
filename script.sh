st_of_buckets_names.txt is file which contain all the S3 buckets
while read bucket_name; do 

		echo "Bucket name: $bucket_name" >> list_of_public_objects.txt #Write the name of the current S3 which is being iterated
			echo "Bucket name: $bucket_name"		               #Print to stdout the name of the current S3 whici is being iterated 	
				while read s3_object; do
							echo "Checking if the following s3_object is private: $s3_object"
									aws s3api get-object-acl --bucket "$bucket_name" --key "$s3_object" | egrep -B4 "\"Permission\": \"READ\"" | egrep -q "AllUsers" #selectin if there is access to all users, 
											#check the exit status of the previous comand, if there is s3 object with public accss it will be grepped from the previous line and the exit status will be 0, since the command executed successfully
													if [ "$?" -eq 0 ];then 
																	echo "Key: $s3_object" >> list_of_public_objects.txt
																			fi
																				done < <(aws s3 ls s3://$bucket_name --recursive | tr -s " " | sed -r 's/[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [0-9]+ //g' | sed 's/^ *//g') #recursivel list the objets of a bucket
																					echo >> list_of_public_objects.txt
																				done < list_of_buckets_names.txt

