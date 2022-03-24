from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import os
import basistheory
from basistheory.api import tokens_api


from ansible.errors import AnsibleParserError
from ansible.plugins.lookup import LookupBase
from ansible.utils.display import Display

display = Display()


class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):

        ret = []

        self.set_options(var_options=variables, direct=kwargs)

        # Defining client wide api_key
        configuration = basistheory.Configuration(
            host='https://api.basistheory.com',
            api_key=os.environ.get('BT_API_KEY')
        )

        with basistheory.ApiClient(configuration) as api_client:
            # Create an instance of the tokens API client
            token_client = tokens_api.TokensApi(api_client)

        for term in terms:
            display.debug("Token Lookkup Lookup Id: %s" % term)

            # retrieve the token
            try:
                response = token_client.get_by_id(id=term)
                ret.append(response)
            except basistheory.ApiException as e:
                raise AnsibleParserError(
                    'Token Lookup Error: Token ID: "%s", BT Error: %s' % (
                        term, e))

        return ret
