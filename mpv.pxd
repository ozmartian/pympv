from libc.stdlib cimport malloc, free
from libc.string cimport strcpy

from client cimport *
from render cimport *
from render_gl cimport *
from stream_cb cimport *
from talloc cimport *

cimport cython

from enum import Enum, IntEnum
import locale

cdef class EndOfFileReached:
    """Data field for MPV_EVENT_END_FILE events

    Wraps: mpv_event_end_file
    """
#    cdef object __weakref__
    cdef public object reason
    cdef public object error
    @staticmethod
    cdef EndOfFileReached create(mpv_event_end_file* eof)
    cdef _init(self, mpv_event_end_file* eof)

cdef class InputDispatch:
#    cdef object __weakref__
    cdef public object arg0
    cdef public object type

    @staticmethod
    cdef InputDispatch create(mpv_event_script_input_dispatch* evt)

    cdef _init(self, mpv_event_script_input_dispatch* input)

cdef class Hook:
    cdef public str name
    cdef public int id
    cdef readonly object _ctx
    @staticmethod
    cdef Hook create(mpv_event_hook *hook, _ctx)

    cdef _init(self, mpv_event_hook *hook, _ctx)

    cdef _continue(self)
cdef class LogMessage:
    """Data field for MPV_EVENT_LOG_MESSAGE events.

    Wraps: mpv_event_log_message
    """
#    cdef object __weakref__
    cdef public str prefix
    cdef public str level
    cdef public str text
    cdef public object log_level
    cdef _init(self, mpv_event_log_message* msg)
    @staticmethod
    cdef LogMessage create(mpv_event_log_message *msg)


cdef class Property:
    """Data field for MPV_EVENT_PROPERTY_CHANGE and MPV_EVENT_GET_PROPERTY_REPLY.

    Wraps: mpv_event_property
    """
#    cdef object __weakref__
    cdef public str name
    cdef public object data
    cdef _init(self, mpv_event_property* prop)
    @staticmethod
    cdef Property create(mpv_event_property* prop)

cdef class Event:
    """Wraps: mpv_event"""
#    cdef object __weakref__
    cdef public object id
    cdef public object error
    cdef public object data
    cdef public object reply_userdata

    cdef _data(self, mpv_event* event, ctx)
    @staticmethod
    cdef Event create(mpv_event* event, ctx)
    cdef _init(self, mpv_event* event, ctx)

cdef class _ReplyUserData:
    cdef object __weakref__
    cdef public int    refcnt
    cdef public object wref
    cdef public object _data

cdef class _PropertyUserData:
    cdef object __weakref__
    cdef public object wref
    cdef readonly object prop_name
    cdef public uint64_t prop_id
    cdef public list   _data

cdef class Context(object):
    """Base class wrapping a context to interact with mpv.

    Assume all calls can raise MPVError.

    Wraps: mpv_create, mpv_destroy and all mpv_handle related calls
    """
    cdef object __weakref__
    cdef readonly object _reply_userdata
    cdef readonly object _prop_userdata
    cdef mpv_handle *_ctx
    cdef readonly object cb_context
    cdef public object callback
    cdef readonly object callbackthread
    cdef readonly set properties
    cdef readonly set options
    cdef dict _props
    cdef dict _opts
    cdef list _dir

    cdef mpv_format _format_for(self, value)
    cdef mpv_node_list* _prep_node_list(self, values, void *ctx = ?)
    cdef mpv_node_list* _prep_node_map(self,  _map, void *ctx = ?)
    cdef mpv_node _prep_native_value_format(self, value, mpv_format fmt, void *ctx = ?)
    cdef mpv_node _prep_native_value(self, value, void *ctx = ?)
    cdef _free_native_value(self, mpv_node node)
    cdef _shutdown_callbackthread(self)
    cdef _shutdown_callback(self)

cdef class RenderContext(object):
    cdef object __weakref__
    cdef mpv_render_context *_glctx
#    cdef mpv_opengl_cb_context *_glctx
#    cdef readonly object _ctx
    cdef readonly object _ctx
    cdef readonly object callback
    cdef readonly object callbackthread

    @staticmethod
    cdef RenderContext create(Context ctx)

    cdef _shutdown_callbackthread(self)
    cdef _shutdown_callback(self)
