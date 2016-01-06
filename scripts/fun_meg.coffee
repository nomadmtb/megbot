# Description:
#	Please add entertaining HPE/Meg related responses here.
#

# General helper functions go here.
#
randomInt = (min, max) ->
	Math.floor(Math.random() * (max-min) + min)

module.exports = (robot) ->

	# Meg responds to people when they ask if they are the ninja
	#
	robot.hear /am i (the|a) ninja\?$/i, (res) ->
		robot.http("http://areyouthe.ninja/api/isninja")

		.get() (err, http_res, body) ->
			if err
				res.reply("I'm not really sure right now. :tired_face:")
				return
			else
				ninja_data = null
				try
					ninja_data = JSON.parse(body)
				catch e
					res.reply("I'm not really sure what to say. Sorry.")
					return

				res.reply("#{ninja_data.result_message} \n #{ninja_data.image_url}")
				

	# Meg responds to people saying something "funny"
	#
	robot.hear /lol|haha|lmao|ha/i, (res) ->
		lols = ["lol", "haha", "lolz", "lmbo", ":stuck_out_tongue:"]

		# Choose reaction
		reaction = lols[randomInt(0, lols.length)]

		# Send reply to user
		res.send("@#{res.message.user.name} #{reaction}")

	# Meg will repond to people asking for the current UTC datetime
	#
	robot.respond /datetime utc$/i, (res) ->
		cur_date = new Date()
		date_str = ""

		date_str += (cur_date.getUTCMonth() + 1) + "/"
		date_str += cur_date.getUTCDate() + "/"
		date_str += cur_date.getUTCFullYear() + " "

		date_str += cur_date.getUTCHours() + ":"
		date_str += cur_date.getUTCMinutes() + " UTC"

		res.reply("Datetime: #{date_str}")

	# Meg will repond to people asking for the current UTC time
	#
	robot.respond /time utc$/i, (res) ->
		cur_date = new Date()
		date_str = ""

		date_str += cur_date.getUTCHours() + ":"
		date_str += cur_date.getUTCMinutes() + " UTC"

		res.reply("Time: #{date_str}")

	# Meg responds to people asking for a chuck norris joke
	#
	robot.respond /tell me a chuck norris joke/i, (res) ->
		robot.http("http://api.icndb.com/jokes/randomd")

		.get() (err, http_res, body) ->
			if err
				res.reply("Sorry, I can't think of a joke at this particular moment")
			else
				joke = null
				try
					joke = JSON.parse(body).value.joke
					joke = joke.replace(/&quot;/g, '\"')
				catch e
					res.reply("I can't remember the exact particulars of the joke. Sorry. :sob:")
					return

				res.reply(joke)
