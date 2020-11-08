import json

from rest_framework import renderers


class UserRenderer(renderers.JSONRenderer):
    charset = 'utf-8'

    def render(self, data, accepted_media_type=None, renderer_context=None):
        if 'errordetail' in str(data).lower():
            response = json.dumps({'errors': data})
        else:
            response = json.dumps({'data': data})
        return response
