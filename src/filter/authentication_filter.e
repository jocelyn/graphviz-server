note
	description: "Authentication filter."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	AUTHENTICATION_FILTER

inherit
	WSF_FILTER_CONTEXT_HANDLER [FILTER_HANDLER_CONTEXT]
		select
			default_create
		end

	WSF_URI_TEMPLATE_CONTEXT_HANDLER [FILTER_HANDLER_CONTEXT]

	USER_MANAGER
		rename
			default_create as urm_default_create
		end

feature -- Basic operations

	execute (ctx: FILTER_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the filter
		local
			l_auth: HTTP_AUTHORIZATION
		do
			create l_auth.make (req.http_authorization)
			if (attached l_auth.type as l_auth_type and then l_auth_type.is_equal ("basic")) and
				attached l_auth.login as l_auth_login and then
				attached l_auth.password as l_auth_password and then
				attached {USER} retrieve_by_name_and_password (l_auth_login, l_auth_password) as  l_user then
				ctx.set_user (l_user)
				execute_next (ctx, req, res)
			else
				handle_unauthorized ("Unauthorized", req, res)
			end
		end

feature {NONE} -- Implementation

	handle_unauthorized (a_description: STRING; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Handle forbidden.
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_plain
			h.put_content_length (a_description.count)
			h.put_current_date
			h.put_header_key_value ({HTTP_HEADER_NAMES}.header_www_authenticate, "Basic realm=%"User%"")
			res.set_status_code ({HTTP_STATUS_CODE}.unauthorized)
			res.put_header_text (h.string)
			res.put_string (a_description)
		end

note
	copyright: "2011-2012, Olivier Ligot, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
