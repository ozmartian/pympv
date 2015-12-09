from libc.stdlib cimport *
from libc.stdio  cimport *
from libc.stdint cimport *
from libc.stddef cimport *

DEF TALLOC_VERSION_MAJOR=2
DEF TALLOC_VERSION_MINOR=2
cdef extern from "stdarg.h" nogil:
    ctypedef struct va_list:
        pass

cdef extern from "talloc.h" nogil:
    int talloc_version_major()
    int talloc_version_minor()
    ctypedef void TALLOC_CTX
    void *talloc(const void *ctx,size_t size);
    void *talloc_int(const char *fmt,...);
    int talloc_free(void *ptr);
    void talloc_free_children(void *ptr);

    void talloc_set_destructor(const void *ptr, int (*destructor)(void *));
    void *talloc_steal(const void *new_ctx, const void *ptr);
    const char *talloc_set_name(const void *ptr, const char *fmt, ...) 
    void *talloc_move(const void *new_ctx, void **pptr);
    void talloc_set_name_const(const void *ptr, const char *name);
    void *talloc_named(const void *context, size_t size,
		   const char *fmt, ...)
    void *talloc_named_const(const void *context, size_t size, const char *name);
    void *talloc_size(const void *ctx, size_t size);
    void *talloc_new(const void *ctx);
    void *talloc_zero_size(const void *ctx, size_t size);
    const char *talloc_get_name(const void *ptr);
    void *talloc_check_name(const void *ptr, const char *name);
    void *talloc_parent(const void *ptr);
    const char *talloc_parent_name(const void *ptr);
    size_t talloc_total_size(const void *ptr);
    size_t talloc_total_blocks(const void *ptr);
    void *talloc_memdup(const void *t, const void *p, size_t size);
    void *_talloc_get_type_abort(const void *ptr, const char *name, const char *location);
    void *talloc_find_parent_byname(const void *ctx, const char *name);
    void *talloc_pool(const void *context, size_t size);
    int talloc_increase_ref_count(const void *ptr);
    size_t talloc_reference_count(const void *ptr);
    void *talloc_reference(const void *ctx, const void *ptr);
    void *_talloc_reference_loc(const void *context, const void *ptr, const char *location);
    int talloc_unlink(const void *context, void *ptr);
    void *talloc_autofree_context();
    size_t talloc_get_size(const void *ctx);
    int talloc_is_parent(const void *context, const void *ptr);
    void *talloc_reparent(const void *old_parent, const void *new_parent, const void *ptr);
    void *talloc_array_size(const void *ctx, size_t size, unsigned count);
    void *talloc_array_ptrtype(const void *ctx, const void *ptr, unsigned count);
    size_t talloc_array_length(const void *ctx);
    void *talloc_realloc_size(const void *ctx, void *ptr, size_t size);
    void *talloc_realloc_fn(const void *context, void *ptr, size_t size);
    char *talloc_strdup(const void *t, const char *p);
    char *talloc_strdup_append(char *s, const char *a);
    char *talloc_strdup_append_buffer(char *s, const char *a);
    char *talloc_strndup(const void *t, const char *p, size_t n);
    char *talloc_strndup_append(char *s, const char *a, size_t n);
    char *talloc_strndup_append_buffer(char *s, const char *a, size_t n);
    char *talloc_vasprintf(const void *t, const char *fmt, va_list ap)
    char *talloc_vasprintf_append(char *s, const char *fmt, va_list ap)
    char *talloc_vasprintf_append_buffer(char *s, const char *fmt, va_list ap)
    char *talloc_asprintf(const void *t, const char *fmt, ...) 
    char *talloc_asprintf_append(char *s, const char *fmt, ...) 
    char *talloc_asprintf_append_buffer(char *s, const char *fmt, ...)
    void talloc_set_log_fn(void (*log_fn)(const char *message));
    void talloc_set_log_stderr();
