note
	description: "Summary description for {ABSTRACT_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ABSTRACT_MANAGER

feature -- DB handler

	db_mgr: SQLITE_DATABASE
		deferred
		end

end
