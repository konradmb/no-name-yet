import linux/input

# Generated @ 2020-08-01T04:27:19+02:00
# Command line:
#   /home/konrad/.nimble/pkgs/nimterop-#head/nimterop/toast -p -r -n -k -l=libevdev.so.2 -o=libevdev_uinput.nim -I /usr/include/libevdev-1.0/ /usr/include/libevdev-1.0/libevdev/libevdev-uinput.h

# const 'LIBEVDEV_DEPRECATED' has unsupported value '__attribute__ ((deprecated))'
{.push hint[ConvFromXtoItselfNotNeeded]: off.}
import macros

macro defineEnum(typ: untyped): untyped =
  result = newNimNode(nnkStmtList)

  # Enum mapped to distinct cint
  result.add quote do:
    type `typ`* = distinct cint

  for i in ["+", "-", "*", "div", "mod", "shl", "shr", "or", "and", "xor", "<", "<=", "==", ">", ">="]:
    let
      ni = newIdentNode(i)
      typout = if i[0] in "<=>": newIdentNode("bool") else: typ # comparisons return bool
    if i[0] == '>': # cannot borrow `>` and `>=` from templates
      let
        nopp = if i.len == 2: newIdentNode("<=") else: newIdentNode("<")
      result.add quote do:
        proc `ni`*(x: `typ`, y: cint): `typout` = `nopp`(y, x)
        proc `ni`*(x: cint, y: `typ`): `typout` = `nopp`(y, x)
        proc `ni`*(x, y: `typ`): `typout` = `nopp`(y, x)
    else:
      result.add quote do:
        proc `ni`*(x: `typ`, y: cint): `typout` {.borrow.}
        proc `ni`*(x: cint, y: `typ`): `typout` {.borrow.}
        proc `ni`*(x, y: `typ`): `typout` {.borrow.}
    result.add quote do:
      proc `ni`*(x: `typ`, y: int): `typout` = `ni`(x, y.cint)
      proc `ni`*(x: int, y: `typ`): `typout` = `ni`(x.cint, y)

  let
    divop = newIdentNode("/")   # `/`()
    dlrop = newIdentNode("$")   # `$`()
    notop = newIdentNode("not") # `not`()
  result.add quote do:
    proc `divop`*(x, y: `typ`): `typ` = `typ`((x.float / y.float).cint)
    proc `divop`*(x: `typ`, y: cint): `typ` = `divop`(x, `typ`(y))
    proc `divop`*(x: cint, y: `typ`): `typ` = `divop`(`typ`(x), y)
    proc `divop`*(x: `typ`, y: int): `typ` = `divop`(x, y.cint)
    proc `divop`*(x: int, y: `typ`): `typ` = `divop`(x.cint, y)

    proc `dlrop`*(x: `typ`): string {.borrow.}
    proc `notop`*(x: `typ`): `typ` {.borrow.}

type va_list* {.importc, header:"<stdarg.h>".} = object


{.pragma: implibevdevuinputHdr,
  header: "/usr/include/libevdev-1.0/libevdev/libevdev-uinput.h".}
{.pragma: implibevdevuinputDyn, dynlib: "libevdev.so.2".}
{.experimental: "codeReordering".}
{.passC: "-I/usr/include/libevdev-1.0/".}
defineEnum(libevdev_read_flag) ## ```
                              ##   @ingroup events
                              ## ```
defineEnum(libevdev_log_priority) ## ```
                                 ##   @ingroup logging
                                 ## ```
defineEnum(libevdev_grab_mode) ## ```
                              ##   @ingroup init
                              ## ```
defineEnum(libevdev_read_status) ## ```
                                ##   @ingroup events
                                ## ```
defineEnum(libevdev_led_value) ## ```
                              ##   @ingroup kernel
                              ## ```
defineEnum(libevdev_uinput_open_mode)
const
  LIBEVDEV_READ_FLAG_SYNC* = (1).libevdev_read_flag ## ```
                                                 ##   < Process data in sync mode
                                                 ## ```
  LIBEVDEV_READ_FLAG_NORMAL* = (2).libevdev_read_flag ## ```
                                                   ##   < Process data in normal mode
                                                   ## ```
  LIBEVDEV_READ_FLAG_FORCE_SYNC* = (4).libevdev_read_flag ## ```
                                                       ##   < Pretend the next event is a SYN_DROPPED and
                                                       ##   					          require the caller to sync
                                                       ## ```
  LIBEVDEV_READ_FLAG_BLOCKING* = (8).libevdev_read_flag ## ```
                                                     ##   < The fd is not in O_NONBLOCK and a read may block
                                                     ## ```
  LIBEVDEV_LOG_ERROR* = (10).libevdev_log_priority ## ```
                                                ##   < critical errors and application bugs
                                                ## ```
  LIBEVDEV_LOG_INFO* = (20).libevdev_log_priority ## ```
                                               ##   < informational messages
                                               ## ```
  LIBEVDEV_LOG_DEBUG* = (30).libevdev_log_priority ## ```
                                                ##   < debug information
                                                ## ```
  LIBEVDEV_GRAB* = (3).libevdev_grab_mode ## ```
                                       ##   < Grab the device if not currently grabbed
                                       ## ```
  LIBEVDEV_UNGRAB* = (4).libevdev_grab_mode ## ```
                                         ##   < Ungrab the device if currently grabbed
                                         ## ```
  LIBEVDEV_READ_STATUS_SUCCESS* = (0).libevdev_read_status ## ```
                                                        ##   libevdev_next_event() has finished without an error
                                                        ##   	 and an event is available for processing.
                                                        ##   	
                                                        ##   	 @see libevdev_next_event
                                                        ## ```
  LIBEVDEV_READ_STATUS_SYNC* = (1).libevdev_read_status ## ```
                                                     ##   Depending on the libevdev_next_event() read flag:
                                                     ##   	 libevdev received a SYN_DROPPED from the device, and the caller should
                                                     ##   	 now resync the device, or,
                                                     ##   	 an event has been read in sync mode.
                                                     ##   	
                                                     ##   	 @see libevdev_next_event
                                                     ## ```
  LIBEVDEV_LED_ON* = (3).libevdev_led_value ## ```
                                         ##   < Turn the LED on
                                         ## ```
  LIBEVDEV_LED_OFF* = (4).libevdev_led_value ## ```
                                          ##   < Turn the LED off
                                          ## ```
  LIBEVDEV_UINPUT_OPEN_MANAGED* = (-2).libevdev_uinput_open_mode ## ```
                                                              ##   < let libevdev open and close @c /dev/uinput
                                                              ## ```
type
  libevdev* {.incompleteStruct, implibevdevuinputHdr, importc: "struct libevdev".} = object
  libevdev_log_func_t* {.importc, implibevdevuinputHdr.} = proc (
      priority: libevdev_log_priority; data: pointer; file: cstring; line: cint;
      `func`: cstring; format: cstring; args: va_list) {.cdecl.}
  libevdev_device_log_func_t* {.importc, implibevdevuinputHdr.} = proc (
      dev: ptr libevdev; priority: libevdev_log_priority; data: pointer; file: cstring;
      line: cint; `func`: cstring; format: cstring; args: va_list) {.cdecl.}
  libevdev_uinput* {.incompleteStruct, implibevdevuinputHdr,
                    importc: "struct libevdev_uinput".} = object
proc libevdev_new*(): ptr libevdev {.importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup init
  ##   
  ##    Initialize a new libevdev device. This function only allocates the
  ##    required memory and initializes the struct to sane default values.
  ##    To actually hook up the device to a kernel device, use
  ##    libevdev_set_fd().
  ##   
  ##    Memory allocated through libevdev_new() must be released by the
  ##    caller with libevdev_free().
  ##   
  ##    @see libevdev_set_fd
  ##    @see libevdev_free
  ## ```
proc libevdev_new_from_fd*(fd: cint; dev: ptr ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup init
  ##   
  ##    Initialize a new libevdev device from the given fd.
  ##   
  ##    This is a shortcut for
  ##   
  ##    @code
  ##    int err;
  ##    struct libevdevdev = libevdev_new();
  ##    err = libevdev_set_fd(dev, fd);
  ##    @endcode
  ##   
  ##    @param fd A file descriptor to the device in O_RDWR or O_RDONLY mode.
  ##    @param[out] dev The newly initialized evdev device.
  ##   
  ##    @return On success, 0 is returned and dev is set to the newly
  ##    allocated struct. On failure, a negative errno is returned and the value
  ##    of dev is undefined.
  ##   
  ##    @see libevdev_free
  ## ```
proc libevdev_free*(dev: ptr libevdev) {.importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup init
  ##   
  ##    Clean up and free the libevdev struct. After completion, the <code>struct
  ##    libevdev</code> is invalid and must not be used.
  ##   
  ##    Note that calling libevdev_free() does not close the file descriptor
  ##    currently associated with this instance.
  ##   
  ##    @param dev The evdev device
  ##   
  ##    @note This function may be called before libevdev_set_fd().
  ## ```
proc libevdev_set_log_function*(logfunc: libevdev_log_func_t; data: pointer) {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup logging
  ##   
  ##    Set a printf-style logging handler for library-internal logging. The default
  ##    logging function is to stdout.
  ##   
  ##    @note The global log handler is only called if no context-specific log
  ##    handler has been set with libevdev_set_device_log_function().
  ##   
  ##    @param logfunc The logging function for this device. If NULL, the current
  ##    logging function is unset and no logging is performed.
  ##    @param data User-specific data passed to the log handler.
  ##   
  ##    @note This function may be called before libevdev_set_fd().
  ##   
  ##    @deprecated Use per-context logging instead, see
  ##    libevdev_set_device_log_function().
  ## ```
proc libevdev_set_log_priority*(priority: libevdev_log_priority) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup logging
  ##   
  ##    Define the minimum level to be printed to the log handler.
  ##    Messages higher than this level are printed, others are discarded. This
  ##    is a global setting and applies to any future logging messages.
  ##   
  ##    @param priority Minimum priority to be printed to the log.
  ##   
  ##    @deprecated Use per-context logging instead, see
  ##    libevdev_set_device_log_function().
  ## ```
proc libevdev_get_log_priority*(): libevdev_log_priority {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup logging
  ##   
  ##    Return the current log priority level. Messages higher than this level
  ##    are printed, others are discarded. This is a global setting.
  ##   
  ##    @return the current log level
  ##   
  ##    @deprecated Use per-context logging instead, see
  ##    libevdev_set_device_log_function().
  ## ```
proc libevdev_set_device_log_function*(dev: ptr libevdev;
                                      logfunc: libevdev_device_log_func_t;
                                      priority: libevdev_log_priority;
                                      data: pointer) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup logging
  ##   
  ##    Set a printf-style logging handler for library-internal logging for this
  ##    device context. The default logging function is NULL, i.e. the global log
  ##    handler is invoked. If a context-specific log handler is set, the global
  ##    log handler is not invoked for this device.
  ##   
  ##    @note This log function applies for this device context only, even if
  ##    another context exists for the same fd.
  ##   
  ##    @param dev The evdev device
  ##    @param logfunc The logging function for this device. If NULL, the current
  ##    logging function is unset and logging falls back to the global log
  ##    handler, if any.
  ##    @param priority Minimum priority to be printed to the log.
  ##    @param data User-specific data passed to the log handler.
  ##   
  ##    @note This function may be called before libevdev_set_fd().
  ##    @since 1.3
  ## ```
proc libevdev_grab*(dev: ptr libevdev; grab: libevdev_grab_mode): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup init
  ##   
  ##    Grab or ungrab the device through a kernel EVIOCGRAB. This prevents other
  ##    clients (including kernel-internal ones such as rfkill) from receiving
  ##    events from this device.
  ##   
  ##    This is generally a bad idea. Don't do this.
  ##   
  ##    Grabbing an already grabbed device, or ungrabbing an ungrabbed device is
  ##    a noop and always succeeds.
  ##   
  ##    A grab is an operation tied to a file descriptor, not a device. If a
  ##    client changes the file descriptor with libevdev_change_fd(), it must
  ##    also re-issue a grab with libevdev_grab().
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param grab If true, grab the device. Otherwise ungrab the device.
  ##   
  ##    @return 0 if the device was successfully grabbed or ungrabbed, or a
  ##    negative errno in case of failure.
  ## ```
proc libevdev_set_fd*(dev: ptr libevdev; fd: cint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup init
  ##   
  ##    Set the fd for this struct and initialize internal data.
  ##    The fd must be in O_RDONLY or O_RDWR mode.
  ##   
  ##    This function may only be called once per device. If the device changed and
  ##    you need to re-read a device, use libevdev_free() and libevdev_new(). If
  ##    you need to change the fd after closing and re-opening the same device, use
  ##    libevdev_change_fd().
  ##   
  ##    A caller should ensure that any events currently pending on the fd are
  ##    drained before the file descriptor is passed to libevdev for
  ##    initialization. Due to how the kernel's ioctl handling works, the initial
  ##    device state will reflect the current device stateafter* applying all
  ##    events currently pending on the fd. Thus, if the fd is not drained, the
  ##    state visible to the caller will be inconsistent with the events
  ##    immediately available on the device. This does not affect state-less
  ##    events like EV_REL.
  ##   
  ##    Unless otherwise specified, libevdev function behavior is undefined until
  ##    a successful call to libevdev_set_fd().
  ##   
  ##    @param dev The evdev device
  ##    @param fd The file descriptor for the device
  ##   
  ##    @return 0 on success, or a negative errno on failure
  ##   
  ##    @see libevdev_change_fd
  ##    @see libevdev_new
  ##    @see libevdev_free
  ## ```
proc libevdev_change_fd*(dev: ptr libevdev; fd: cint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup init
  ##   
  ##    Change the fd for this device, without re-reading the actual device. If the fd
  ##    changes after initializing the device, for example after a VT-switch in the
  ##    X.org X server, this function updates the internal fd to the newly opened.
  ##    No check is made that new fd points to the same device. If the device has
  ##    changed, libevdev's behavior is undefined.
  ##   
  ##    libevdev does not sync itself after changing the fd and keeps the current
  ##    device state. Use libevdev_next_event with the
  ##    @ref LIBEVDEV_READ_FLAG_FORCE_SYNC flag to force a re-sync.
  ##   
  ##    The example code below illustrates how to force a re-sync of the
  ##    library-internal state. Note that this code doesn't handle the events in
  ##    the caller, it merely forces an update of the internal library state.
  ##    @code
  ##        struct input_event ev;
  ##        libevdev_change_fd(dev, new_fd);
  ##        libevdev_next_event(dev, LIBEVDEV_READ_FLAG_FORCE_SYNC, &ev);
  ##        while (libevdev_next_event(dev, LIBEVDEV_READ_FLAG_SYNC, &ev) == LIBEVDEV_READ_STATUS_SYNC)
  ##                                ;  noop
  ##    @endcode
  ##   
  ##    The fd may be open in O_RDONLY or O_RDWR.
  ##   
  ##    After changing the fd, the device is assumed ungrabbed and a caller must
  ##    call libevdev_grab() again.
  ##   
  ##    It is an error to call this function before calling libevdev_set_fd().
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param fd The new fd
  ##   
  ##    @return 0 on success, or -1 on failure.
  ##   
  ##    @see libevdev_set_fd
  ## ```
proc libevdev_get_fd*(dev: ptr libevdev): cint {.importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup init
  ##   
  ##    @param dev The evdev device
  ##   
  ##    @return The previously set fd, or -1 if none had been set previously.
  ##    @note This function may be called before libevdev_set_fd().
  ## ```
proc libevdev_next_event*(dev: ptr libevdev; flags: cuint; ev: ptr input_event): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup events
  ##   
  ##    Get the next event from the device. This function operates in two different
  ##    modes: normal mode or sync mode.
  ##   
  ##    In normal mode (when flags has @ref LIBEVDEV_READ_FLAG_NORMAL set), this
  ##    function returns @ref LIBEVDEV_READ_STATUS_SUCCESS and returns the event
  ##    in the argument @p ev. If no events are available at this
  ##    time, it returns -EAGAIN and ev is undefined.
  ##   
  ##    If the current event is an EV_SYN SYN_DROPPED event, this function returns
  ##    @ref LIBEVDEV_READ_STATUS_SYNC and ev is set to the EV_SYN event.
  ##    The caller should now call this function with the
  ##    @ref LIBEVDEV_READ_FLAG_SYNC flag set, to get the set of events that make up the
  ##    device state delta. This function returns @ref LIBEVDEV_READ_STATUS_SYNC for
  ##    each event part of that delta, until it returns -EAGAIN once all events
  ##    have been synced. For more details on what libevdev does to sync after a
  ##    SYN_DROPPED event, see @ref syn_dropped.
  ##   
  ##    If a device needs to be synced by the caller but the caller does not call
  ##    with the @ref LIBEVDEV_READ_FLAG_SYNC flag set, all events from the diff are
  ##    dropped after libevdev updates its internal state and event processing
  ##    continues as normal. Note that the current slot and the state of touch
  ##    points may have updated during the SYN_DROPPED event, it is strongly
  ##    recommended that a caller ignoring all sync events calls
  ##    libevdev_get_current_slot() and checks the ABS_MT_TRACKING_ID values for
  ##    all slots.
  ##   
  ##    If a device has changed state without events being enqueued in libevdev,
  ##    e.g. after changing the file descriptor, use the @ref
  ##    LIBEVDEV_READ_FLAG_FORCE_SYNC flag. This triggers an internal sync of the
  ##    device and libevdev_next_event() returns @ref LIBEVDEV_READ_STATUS_SYNC.
  ##    Any state changes are available as events as described above. If
  ##    @ref LIBEVDEV_READ_FLAG_FORCE_SYNC is set, the value of ev is undefined.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param flags Set of flags to determine behaviour. If @ref LIBEVDEV_READ_FLAG_NORMAL
  ##    is set, the next event is read in normal mode. If @ref LIBEVDEV_READ_FLAG_SYNC is
  ##    set, the next event is read in sync mode.
  ##    @param ev On success, set to the current event.
  ##    @return On failure, a negative errno is returned.
  ##    @retval LIBEVDEV_READ_STATUS_SUCCESS One or more events were read of the
  ##    device and ev points to the next event in the queue
  ##    @retval -EAGAIN No events are currently available on the device
  ##    @retval LIBEVDEV_READ_STATUS_SYNC A SYN_DROPPED event was received, or a
  ##    synced event was returned and ev points to the SYN_DROPPED event
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_has_event_pending*(dev: ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup events
  ##   
  ##    Check if there are events waiting for us. This function does not read an
  ##    event off the fd and may not access the fd at all. If there are events
  ##    queued internally this function will return non-zero. If the internal
  ##    queue is empty, this function will poll the file descriptor for data.
  ##   
  ##    This is a convenience function for simple processes, most complex programs
  ##    are expected to use select(2) or poll(2) on the file descriptor. The kernel
  ##    guarantees that if data is available, it is a multiple of sizeof(struct
  ##    input_event), and thus calling libevdev_next_event() when select(2) or
  ##    poll(2) return is safe. You do not need libevdev_has_event_pending() if
  ##    you're using select(2) or poll(2).
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @return On failure, a negative errno is returned.
  ##    @retval 0 No event is currently available
  ##    @retval 1 One or more events are available on the fd
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_get_name*(dev: ptr libevdev): cstring {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Retrieve the device's name, either as set by the caller or as read from
  ##    the kernel. The string returned is valid until libevdev_free() or until
  ##    libevdev_set_name(), whichever comes earlier.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return The device name as read off the kernel device. The name is never
  ##    NULL but it may be the empty string.
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_set_name*(dev: ptr libevdev; name: cstring) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Change the device's name as returned by libevdev_get_name(). This
  ##    function destroys the string previously returned by libevdev_get_name(),
  ##    a caller must take care that no references are kept.
  ##   
  ##    @param dev The evdev device
  ##    @param name The new, non-NULL, name to assign to this device.
  ##   
  ##    @note This function may be called before libevdev_set_fd(). A call to
  ##    libevdev_set_fd() will overwrite any previously set value.
  ## ```
proc libevdev_get_phys*(dev: ptr libevdev): cstring {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Retrieve the device's physical location, either as set by the caller or
  ##    as read from the kernel. The string returned is valid until
  ##    libevdev_free() or until libevdev_set_phys(), whichever comes earlier.
  ##   
  ##    Virtual devices such as uinput devices have no phys location.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return The physical location of this device, or NULL if there is none
  ##   
  ##    @note This function is signal safe.
  ## ```
proc libevdev_set_phys*(dev: ptr libevdev; phys: cstring) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Change the device's physical location as returned by libevdev_get_phys().
  ##    This function destroys the string previously returned by
  ##    libevdev_get_phys(), a caller must take care that no references are kept.
  ##   
  ##    @param dev The evdev device
  ##    @param phys The new phys to assign to this device.
  ##   
  ##    @note This function may be called before libevdev_set_fd(). A call to
  ##    libevdev_set_fd() will overwrite any previously set value.
  ## ```
proc libevdev_get_uniq*(dev: ptr libevdev): cstring {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Retrieve the device's unique identifier, either as set by the caller or
  ##    as read from the kernel. The string returned is valid until
  ##    libevdev_free() or until libevdev_set_uniq(), whichever comes earlier.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return The unique identifier for this device, or NULL if there is none
  ##   
  ##    @note This function is signal safe.
  ## ```
proc libevdev_set_uniq*(dev: ptr libevdev; uniq: cstring) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Change the device's unique identifier as returned by libevdev_get_uniq().
  ##    This function destroys the string previously returned by
  ##    libevdev_get_uniq(), a caller must take care that no references are kept.
  ##   
  ##    @param dev The evdev device
  ##    @param uniq The new uniq to assign to this device.
  ##   
  ##    @note This function may be called before libevdev_set_fd(). A call to
  ##    libevdev_set_fd() will overwrite any previously set value.
  ## ```
proc libevdev_get_id_product*(dev: ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return The device's product ID
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_set_id_product*(dev: ptr libevdev; product_id: cint) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    @param dev The evdev device
  ##    @param product_id The product ID to assign to this device
  ##   
  ##    @note This function may be called before libevdev_set_fd(). A call to
  ##    libevdev_set_fd() will overwrite any previously set value. Even though
  ##    the function accepts an int for product_id the value is truncated at 16
  ##    bits.
  ## ```
proc libevdev_get_id_vendor*(dev: ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return The device's vendor ID
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_set_id_vendor*(dev: ptr libevdev; vendor_id: cint) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    @param dev The evdev device
  ##    @param vendor_id The vendor ID to assign to this device
  ##   
  ##    @note This function may be called before libevdev_set_fd(). A call to
  ##    libevdev_set_fd() will overwrite any previously set value. Even though
  ##    the function accepts an int for vendor_id the value is truncated at 16
  ##    bits.
  ## ```
proc libevdev_get_id_bustype*(dev: ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return The device's bus type
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_set_id_bustype*(dev: ptr libevdev; bustype: cint) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    @param dev The evdev device
  ##    @param bustype The bustype to assign to this device
  ##   
  ##    @note This function may be called before libevdev_set_fd(). A call to
  ##    libevdev_set_fd() will overwrite any previously set value. Even though
  ##    the function accepts an int for bustype the value is truncated at 16
  ##    bits.
  ## ```
proc libevdev_get_id_version*(dev: ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return The device's firmware version
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_set_id_version*(dev: ptr libevdev; version: cint) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    @param dev The evdev device
  ##    @param version The version to assign to this device
  ##   
  ##    @note This function may be called before libevdev_set_fd(). A call to
  ##    libevdev_set_fd() will overwrite any previously set value. Even though
  ##    the function accepts an int for version the value is truncated at 16
  ##    bits.
  ## ```
proc libevdev_get_driver_version*(dev: ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return The driver version for this device
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_has_property*(dev: ptr libevdev; prop: cuint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param prop The input property to query for, one of INPUT_PROP_...
  ##   
  ##    @return 1 if the device provides this input property, or 0 otherwise.
  ##   
  ##    @note This function is signal-safe
  ## ```
proc libevdev_enable_property*(dev: ptr libevdev; prop: cuint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    @param dev The evdev device
  ##    @param prop The input property to enable, one of INPUT_PROP_...
  ##   
  ##    @return 0 on success or -1 on failure
  ##   
  ##    @note This function may be called before libevdev_set_fd(). A call to
  ##    libevdev_set_fd() will overwrite any previously set value.
  ## ```
proc libevdev_has_event_type*(dev: ptr libevdev; `type`: cuint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param type The event type to query for, one of EV_SYN, EV_REL, etc.
  ##   
  ##    @return 1 if the device supports this event type, or 0 otherwise.
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_has_event_code*(dev: ptr libevdev; `type`: cuint; code: cuint): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param type The event type for the code to query (EV_SYN, EV_REL, etc.)
  ##    @param code The event code to query for, one of ABS_X, REL_X, etc.
  ##   
  ##    @return 1 if the device supports this event type and code, or 0 otherwise.
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_get_abs_minimum*(dev: ptr libevdev; code: cuint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Get the minimum axis value for the given axis, as advertised by the kernel.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code The EV_ABS event code to query for, one of ABS_X, ABS_Y, etc.
  ##   
  ##    @return axis minimum for the given axis or 0 if the axis is invalid
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_get_abs_maximum*(dev: ptr libevdev; code: cuint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Get the maximum axis value for the given axis, as advertised by the kernel.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code The EV_ABS event code to query for, one of ABS_X, ABS_Y, etc.
  ##   
  ##    @return axis maximum for the given axis or 0 if the axis is invalid
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_get_abs_fuzz*(dev: ptr libevdev; code: cuint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Get the axis fuzz for the given axis, as advertised by the kernel.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code The EV_ABS event code to query for, one of ABS_X, ABS_Y, etc.
  ##   
  ##    @return axis fuzz for the given axis or 0 if the axis is invalid
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_get_abs_flat*(dev: ptr libevdev; code: cuint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Get the axis flat for the given axis, as advertised by the kernel.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code The EV_ABS event code to query for, one of ABS_X, ABS_Y, etc.
  ##   
  ##    @return axis flat for the given axis or 0 if the axis is invalid
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_get_abs_resolution*(dev: ptr libevdev; code: cuint): cint {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Get the axis resolution for the given axis, as advertised by the kernel.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code The EV_ABS event code to query for, one of ABS_X, ABS_Y, etc.
  ##   
  ##    @return axis resolution for the given axis or 0 if the axis is invalid
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_get_abs_info*(dev: ptr libevdev; code: cuint): ptr input_absinfo {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Get the axis info for the given axis, as advertised by the kernel.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code The EV_ABS event code to query for, one of ABS_X, ABS_Y, etc.
  ##   
  ##    @return The input_absinfo for the given code, or NULL if the device does
  ##    not support this event code.
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_get_event_value*(dev: ptr libevdev; `type`: cuint; code: cuint): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Behaviour of this function is undefined if the device does not provide
  ##    the event.
  ##   
  ##    If the device supports ABS_MT_SLOT, the value returned for any ABS_MT_*
  ##    event code is the value of the currently active slot. You should use
  ##    libevdev_get_slot_value() instead.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param type The event type for the code to query (EV_SYN, EV_REL, etc.)
  ##    @param code The event code to query for, one of ABS_X, REL_X, etc.
  ##   
  ##    @return The current value of the event.
  ##   
  ##    @note This function is signal-safe.
  ##    @note The value for ABS_MT_ events is undefined, use
  ##    libevdev_get_slot_value() instead
  ##   
  ##    @see libevdev_get_slot_value
  ## ```
proc libevdev_set_event_value*(dev: ptr libevdev; `type`: cuint; code: cuint;
                              value: cint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Set the value for a given event type and code. This only makes sense for
  ##    some event types, e.g. setting the value for EV_REL is pointless.
  ##   
  ##    This is a local modification only affecting only this representation of
  ##    this device. A future call to libevdev_get_event_value() will return this
  ##    value, unless the value was overwritten by an event.
  ##   
  ##    If the device supports ABS_MT_SLOT, the value set for any ABS_MT_*
  ##    event code is the value of the currently active slot. You should use
  ##    libevdev_set_slot_value() instead.
  ##   
  ##    If the device supports ABS_MT_SLOT and the type is EV_ABS and the code is
  ##    ABS_MT_SLOT, the value must be a positive number less then the number of
  ##    slots on the device. Otherwise, libevdev_set_event_value() returns -1.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param type The event type for the code to query (EV_SYN, EV_REL, etc.)
  ##    @param code The event code to set the value for, one of ABS_X, LED_NUML, etc.
  ##    @param value The new value to set
  ##   
  ##    @return 0 on success, or -1 on failure.
  ##    @retval -1
  ##    - the device does not have the event type or
  ##    - code enabled, or the code is outside the, or
  ##    - the code is outside the allowed limits for the given type, or
  ##    - the type cannot be set, or
  ##    - the value is not permitted for the given code.
  ##   
  ##    @see libevdev_set_slot_value
  ##    @see libevdev_get_event_value
  ## ```
proc libevdev_fetch_event_value*(dev: ptr libevdev; `type`: cuint; code: cuint;
                                value: ptr cint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Fetch the current value of the event type. This is a shortcut for
  ##   
  ##    @code
  ##      if (libevdev_has_event_type(dev, t) && libevdev_has_event_code(dev, t, c))
  ##           val = libevdev_get_event_value(dev, t, c);
  ##    @endcode
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param type The event type for the code to query (EV_SYN, EV_REL, etc.)
  ##    @param code The event code to query for, one of ABS_X, REL_X, etc.
  ##    @param[out] value The current value of this axis returned.
  ##   
  ##    @return If the device supports this event type and code, the return value is
  ##    non-zero and value is set to the current value of this axis. Otherwise,
  ##    0 is returned and value is unmodified.
  ##   
  ##    @note This function is signal-safe.
  ##    @note The value for ABS_MT_ events is undefined, use
  ##    libevdev_fetch_slot_value() instead
  ##   
  ##    @see libevdev_fetch_slot_value
  ## ```
proc libevdev_get_slot_value*(dev: ptr libevdev; slot: cuint; code: cuint): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup mt
  ##   
  ##    Return the current value of the code for the given slot.
  ##   
  ##    The return value is undefined for a slot exceeding the available slots on
  ##    the device, for a code that is not in the permitted ABS_MT range or for a
  ##    device that does not have slots.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param slot The numerical slot number, must be smaller than the total number
  ##    of slots on this device
  ##    @param code The event code to query for, one of ABS_MT_POSITION_X, etc.
  ##   
  ##    @note This function is signal-safe.
  ##    @note The value for events other than ABS_MT_ is undefined, use
  ##    libevdev_fetch_value() instead
  ##   
  ##    @see libevdev_get_event_value
  ## ```
proc libevdev_set_slot_value*(dev: ptr libevdev; slot: cuint; code: cuint; value: cint): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Set the value for a given code for the given slot.
  ##   
  ##    This is a local modification only affecting only this representation of
  ##    this device. A future call to libevdev_get_slot_value() will return this
  ##    value, unless the value was overwritten by an event.
  ##   
  ##    This function does not set event values for axes outside the ABS_MT range,
  ##    use libevdev_set_event_value() instead.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param slot The numerical slot number, must be smaller than the total number
  ##    of slots on this device
  ##    @param code The event code to set the value for, one of ABS_MT_POSITION_X, etc.
  ##    @param value The new value to set
  ##   
  ##    @return 0 on success, or -1 on failure.
  ##    @retval -1
  ##    - the device does not have the event code enabled, or
  ##    - the code is outside the allowed limits for multitouch events, or
  ##    - the slot number is outside the limits for this device, or
  ##    - the device does not support multitouch events.
  ##   
  ##    @see libevdev_set_event_value
  ##    @see libevdev_get_slot_value
  ## ```
proc libevdev_fetch_slot_value*(dev: ptr libevdev; slot: cuint; code: cuint;
                               value: ptr cint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup mt
  ##   
  ##    Fetch the current value of the code for the given slot. This is a shortcut for
  ##   
  ##    @code
  ##      if (libevdev_has_event_type(dev, EV_ABS) &&
  ##          libevdev_has_event_code(dev, EV_ABS, c) &&
  ##          slot < device->number_of_slots)
  ##          val = libevdev_get_slot_value(dev, slot, c);
  ##    @endcode
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param slot The numerical slot number, must be smaller than the total number
  ##    of slots on this device
  ##    @param[out] value The current value of this axis returned.
  ##   
  ##    @param code The event code to query for, one of ABS_MT_POSITION_X, etc.
  ##    @return If the device supports this event code, the return value is
  ##    non-zero and value is set to the current value of this axis. Otherwise, or
  ##    if the event code is not an ABS_MT_* event code, 0 is returned and value
  ##    is unmodified.
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_get_num_slots*(dev: ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup mt
  ##   
  ##    Get the number of slots supported by this device.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return The number of slots supported, or -1 if the device does not provide
  ##    any slots
  ##   
  ##    @note A device may provide ABS_MT_SLOT but a total number of 0 slots. Hence
  ##    the return value of -1 for "device does not provide slots at all"
  ## ```
proc libevdev_get_current_slot*(dev: ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup mt
  ##   
  ##    Get the currently active slot. This may differ from the value
  ##    an ioctl may return at this time as events may have been read off the fd
  ##    since changing the slot value but those events are still in the buffer
  ##    waiting to be processed. The returned value is the value a caller would
  ##    see if it were to process events manually one-by-one.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##   
  ##    @return the currently active slot (logically)
  ##   
  ##    @note This function is signal-safe.
  ## ```
proc libevdev_set_abs_minimum*(dev: ptr libevdev; code: cuint; min: cint) {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Change the minimum for the given EV_ABS event code, if the code exists.
  ##    This function has no effect if libevdev_has_event_code() returns false for
  ##    this code.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code One of ABS_X, ABS_Y, ...
  ##    @param min The new minimum for this axis
  ## ```
proc libevdev_set_abs_maximum*(dev: ptr libevdev; code: cuint; max: cint) {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Change the maximum for the given EV_ABS event code, if the code exists.
  ##    This function has no effect if libevdev_has_event_code() returns false for
  ##    this code.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code One of ABS_X, ABS_Y, ...
  ##    @param max The new maxium for this axis
  ## ```
proc libevdev_set_abs_fuzz*(dev: ptr libevdev; code: cuint; fuzz: cint) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Change the fuzz for the given EV_ABS event code, if the code exists.
  ##    This function has no effect if libevdev_has_event_code() returns false for
  ##    this code.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code One of ABS_X, ABS_Y, ...
  ##    @param fuzz The new fuzz for this axis
  ## ```
proc libevdev_set_abs_flat*(dev: ptr libevdev; code: cuint; flat: cint) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Change the flat for the given EV_ABS event code, if the code exists.
  ##    This function has no effect if libevdev_has_event_code() returns false for
  ##    this code.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code One of ABS_X, ABS_Y, ...
  ##    @param flat The new flat for this axis
  ## ```
proc libevdev_set_abs_resolution*(dev: ptr libevdev; code: cuint; resolution: cint) {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Change the resolution for the given EV_ABS event code, if the code exists.
  ##    This function has no effect if libevdev_has_event_code() returns false for
  ##    this code.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code One of ABS_X, ABS_Y, ...
  ##    @param resolution The new axis resolution
  ## ```
proc libevdev_set_abs_info*(dev: ptr libevdev; code: cuint; abs: ptr input_absinfo) {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Change the abs info for the given EV_ABS event code, if the code exists.
  ##    This function has no effect if libevdev_has_event_code() returns false for
  ##    this code.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code One of ABS_X, ABS_Y, ...
  ##    @param abs The new absolute axis data (min, max, fuzz, flat, resolution)
  ## ```
proc libevdev_enable_event_type*(dev: ptr libevdev; `type`: cuint): cint {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Forcibly enable an event type on this device, even if the underlying
  ##    device does not support it. While this cannot make the device actually
  ##    report such events, it will now return true for libevdev_has_event_type().
  ##   
  ##    This is a local modification only affecting only this representation of
  ##    this device.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param type The event type to enable (EV_ABS, EV_KEY, ...)
  ##   
  ##    @return 0 on success or -1 otherwise
  ##   
  ##    @see libevdev_has_event_type
  ## ```
proc libevdev_disable_event_type*(dev: ptr libevdev; `type`: cuint): cint {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Forcibly disable an event type on this device, even if the underlying
  ##    device provides it. This effectively mutes the respective set of
  ##    events. libevdev will filter any events matching this type and none will
  ##    reach the caller. libevdev_has_event_type() will return false for this
  ##    type.
  ##   
  ##    In most cases, a caller likely only wants to disable a single code, not
  ##    the whole type. Use libevdev_disable_event_code() for that.
  ##   
  ##    Disabling EV_SYN will not work. Don't shoot yourself in the foot.
  ##    It hurts.
  ##   
  ##    This is a local modification only affecting only this representation of
  ##    this device.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param type The event type to disable (EV_ABS, EV_KEY, ...)
  ##   
  ##    @return 0 on success or -1 otherwise
  ##   
  ##    @see libevdev_has_event_type
  ##    @see libevdev_disable_event_type
  ## ```
proc libevdev_enable_event_code*(dev: ptr libevdev; `type`: cuint; code: cuint;
                                data: pointer): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Forcibly enable an event code on this device, even if the underlying
  ##    device does not support it. While this cannot make the device actually
  ##    report such events, it will now return true for libevdev_has_event_code().
  ##   
  ##    The last argument depends on the type and code:
  ##    - If type is EV_ABS, data must be a pointer to a struct input_absinfo
  ##      containing the data for this axis.
  ##    - If type is EV_REP, data must be a pointer to a int containing the data
  ##      for this axis
  ##    - For all other types, the argument must be NULL.
  ##   
  ##    This function calls libevdev_enable_event_type() if necessary.
  ##   
  ##    This is a local modification only affecting only this representation of
  ##    this device.
  ##   
  ##    If this function is called with a type of EV_ABS and EV_REP on a device
  ##    that already has the given event code enabled, the values in data
  ##    overwrite the previous values.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param type The event type to enable (EV_ABS, EV_KEY, ...)
  ##    @param code The event code to enable (ABS_X, REL_X, etc.)
  ##    @param data If type is EV_ABS, data points to a struct input_absinfo. If type is EV_REP, data
  ##    points to an integer. Otherwise, data must be NULL.
  ##   
  ##    @return 0 on success or -1 otherwise
  ##   
  ##    @see libevdev_enable_event_type
  ## ```
proc libevdev_disable_event_code*(dev: ptr libevdev; `type`: cuint; code: cuint): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Forcibly disable an event code on this device, even if the underlying
  ##    device provides it. This effectively mutes the respective set of
  ##    events. libevdev will filter any events matching this type and code and
  ##    none will reach the caller. libevdev_has_event_code() will return false for
  ##    this code.
  ##   
  ##    Disabling all event codes for a given type will not disable the event
  ##    type. Use libevdev_disable_event_type() for that.
  ##   
  ##    This is a local modification only affecting only this representation of
  ##    this device.
  ##   
  ##    Disabling codes of type EV_SYN will not work. Don't shoot yourself in the
  ##    foot. It hurts.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param type The event type to disable (EV_ABS, EV_KEY, ...)
  ##    @param code The event code to disable (ABS_X, REL_X, etc.)
  ##   
  ##    @return 0 on success or -1 otherwise
  ##   
  ##    @see libevdev_has_event_code
  ##    @see libevdev_disable_event_type
  ## ```
proc libevdev_kernel_set_abs_info*(dev: ptr libevdev; code: cuint;
                                  abs: ptr input_absinfo): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Set the device's EV_ABS axis to the value defined in the abs
  ##    parameter. This will be written to the kernel.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code The EV_ABS event code to modify, one of ABS_X, ABS_Y, etc.
  ##    @param abs Axis info to set the kernel axis to
  ##   
  ##    @return 0 on success, or a negative errno on failure
  ##   
  ##    @see libevdev_enable_event_code
  ## ```
proc libevdev_kernel_set_led_value*(dev: ptr libevdev; code: cuint;
                                   value: libevdev_led_value): cint {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Turn an LED on or off. Convenience function, if you need to modify multiple
  ##    LEDs simultaneously, use libevdev_kernel_set_led_values() instead.
  ##   
  ##    @note enabling an LED requires write permissions on the device's file descriptor.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param code The EV_LED event code to modify, one of LED_NUML, LED_CAPSL, ...
  ##    @param value Specifies whether to turn the LED on or off
  ##    @return 0 on success, or a negative errno on failure
  ## ```
proc libevdev_kernel_set_led_values*(dev: ptr libevdev): cint {.importc, cdecl,
    implibevdevuinputDyn, varargs.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Turn multiple LEDs on or off simultaneously. This function expects a pair
  ##    of LED codes and values to set them to, terminated by a -1. For example, to
  ##    switch the NumLock LED on but the CapsLock LED off, use:
  ##   
  ##    @code
  ##        libevdev_kernel_set_led_values(dev, LED_NUML, LIBEVDEV_LED_ON,
  ##                                            LED_CAPSL, LIBEVDEV_LED_OFF,
  ##                                            -1);
  ##    @endcode
  ##   
  ##    If any LED code or value is invalid, this function returns -EINVAL and no
  ##    LEDs are modified.
  ##   
  ##    @note enabling an LED requires write permissions on the device's file descriptor.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param ... A pair of LED_* event codes and libevdev_led_value_t, followed by
  ##    -1 to terminate the list.
  ##    @return 0 on success, or a negative errno on failure
  ## ```
proc libevdev_set_clock_id*(dev: ptr libevdev; clockid: cint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup kernel
  ##   
  ##    Set the clock ID to be used for timestamps. Further events from this device
  ##    will report an event time based on the given clock.
  ##   
  ##    This is a modification only affecting this representation of
  ##    this device.
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param clockid The clock to use for future events. Permitted values
  ##    are CLOCK_MONOTONIC and CLOCK_REALTIME (the default).
  ##    @return 0 on success, or a negative errno on failure
  ## ```
proc libevdev_event_is_type*(ev: ptr input_event; `type`: cuint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Helper function to check if an event is of a specific type. This is
  ##    virtually the same as:
  ##   
  ##         ev->type == type
  ##   
  ##    with the exception that some sanity checks are performed to ensure type
  ##    is valid.
  ##   
  ##    @note The ranges for types are compiled into libevdev. If the kernel
  ##    changes the max value, libevdev will not automatically pick these up.
  ##   
  ##    @param ev The input event to check
  ##    @param type Input event type to compare the event against (EV_REL, EV_ABS,
  ##    etc.)
  ##   
  ##    @return 1 if the event type matches the given type, 0 otherwise (or if
  ##    type is invalid)
  ## ```
proc libevdev_event_is_code*(ev: ptr input_event; `type`: cuint; code: cuint): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Helper function to check if an event is of a specific type and code. This
  ##    is virtually the same as:
  ##   
  ##         ev->type == type && ev->code == code
  ##   
  ##    with the exception that some sanity checks are performed to ensure type and
  ##    code are valid.
  ##   
  ##    @note The ranges for types and codes are compiled into libevdev. If the kernel
  ##    changes the max value, libevdev will not automatically pick these up.
  ##   
  ##    @param ev The input event to check
  ##    @param type Input event type to compare the event against (EV_REL, EV_ABS,
  ##    etc.)
  ##    @param code Input event code to compare the event against (ABS_X, REL_X,
  ##    etc.)
  ##   
  ##    @return 1 if the event type matches the given type and code, 0 otherwise
  ##    (or if type/code are invalid)
  ## ```
proc libevdev_event_type_get_name*(`type`: cuint): cstring {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    @param type The event type to return the name for.
  ##   
  ##    @return The name of the given event type (e.g. EV_ABS) or NULL for an
  ##    invalid type
  ##   
  ##    @note The list of names is compiled into libevdev. If the kernel adds new
  ##    defines for new event types, libevdev will not automatically pick these up.
  ## ```
proc libevdev_event_code_get_name*(`type`: cuint; code: cuint): cstring {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    @param type The event type for the code to query (EV_SYN, EV_REL, etc.)
  ##    @param code The event code to return the name for (e.g. ABS_X)
  ##   
  ##    @return The name of the given event code (e.g. ABS_X) or NULL for an
  ##    invalid type or code
  ##   
  ##    @note The list of names is compiled into libevdev. If the kernel adds new
  ##    defines for new event codes, libevdev will not automatically pick these up.
  ## ```
proc libevdev_event_value_get_name*(`type`: cuint; code: cuint; value: cint): cstring {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    This function resolves the event value for a code.
  ##   
  ##    For almost all event codes this will return NULL as the value is just a
  ##    numerical value. As of kernel 4.17, the only event code that will return
  ##    a non-NULL value is EV_ABS/ABS_MT_TOOL_TYPE.
  ##   
  ##    @param type The event type for the value to query (EV_ABS, etc.)
  ##    @param code The event code for the value to query (e.g. ABS_MT_TOOL_TYPE)
  ##    @param value The event value to return the name for (e.g. MT_TOOL_PALM)
  ##   
  ##    @return The name of the given event value (e.g. MT_TOOL_PALM) or NULL for
  ##    an invalid type or code or NULL for an axis that has numerical values
  ##    only.
  ##   
  ##    @note The list of names is compiled into libevdev. If the kernel adds new
  ##    defines for new event values, libevdev will not automatically pick these up.
  ## ```
proc libevdev_property_get_name*(prop: cuint): cstring {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    @param prop The input prop to return the name for (e.g. INPUT_PROP_BUTTONPAD)
  ##   
  ##    @return The name of the given input prop (e.g. INPUT_PROP_BUTTONPAD) or NULL for an
  ##    invalid property
  ##   
  ##    @note The list of names is compiled into libevdev. If the kernel adds new
  ##    defines for new properties libevdev will not automatically pick these up.
  ##    @note On older kernels input properties may not be defined and
  ##    libevdev_property_get_name() will always return NULL
  ## ```
proc libevdev_event_type_get_max*(`type`: cuint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    @param type The event type to return the maximum for (EV_ABS, EV_REL, etc.). No max is defined for
  ##    EV_SYN.
  ##   
  ##    @return The max value defined for the given event type, e.g. ABS_MAX for a type of EV_ABS, or -1
  ##    for an invalid type.
  ##   
  ##    @note The max value is compiled into libevdev. If the kernel changes the
  ##    max value, libevdev will not automatically pick these up.
  ## ```
proc libevdev_event_type_from_name*(name: cstring): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event-type by its name. Event-types start with "EV_" followed by
  ##    the name (eg., "EV_ABS"). The "EV_" prefix must be included in the name. It
  ##    returns the constant assigned to the event-type or -1 if not found.
  ##   
  ##    @param name A non-NULL string describing an input-event type ("EV_KEY",
  ##    "EV_ABS", ...), zero-terminated.
  ##   
  ##    @return The given type constant for the passed name or -1 if not found.
  ##   
  ##    @note EV_MAX is also recognized.
  ## ```
proc libevdev_event_type_from_name_n*(name: cstring; len: uint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event-type by its name. Event-types start with "EV_" followed by
  ##    the name (eg., "EV_ABS"). The "EV_" prefix must be included in the name. It
  ##    returns the constant assigned to the event-type or -1 if not found.
  ##   
  ##    @param name A non-NULL string describing an input-event type ("EV_KEY",
  ##    "EV_ABS", ...).
  ##    @param len The length of the passed string excluding any terminating 0
  ##    character.
  ##   
  ##    @return The given type constant for the passed name or -1 if not found.
  ##   
  ##    @note EV_MAX is also recognized.
  ## ```
proc libevdev_event_code_from_name*(`type`: cuint; name: cstring): cint {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event code by its type and name. Event codes start with a fixed
  ##    prefix followed by their name (eg., "ABS_X"). The prefix must be included in
  ##    the name. It returns the constant assigned to the event code or -1 if not
  ##    found.
  ##   
  ##    You have to pass the event type where to look for the name. For instance, to
  ##    resolve "ABS_X" you need to pass EV_ABS as type and "ABS_X" as string.
  ##    Supported event codes are codes starting with SYN_, KEY_, BTN_, REL_, ABS_,
  ##    MSC_, SND_, SW_, LED_, REP_, FF_.
  ##   
  ##    @param type The event type (EV_* constant) where to look for the name.
  ##    @param name A non-NULL string describing an input-event code ("KEY_A",
  ##    "ABS_X", "BTN_Y", ...), zero-terminated.
  ##   
  ##    @return The given code constant for the passed name or -1 if not found.
  ## ```
proc libevdev_event_code_from_name_n*(`type`: cuint; name: cstring; len: uint): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event code by its type and name. Event codes start with a fixed
  ##    prefix followed by their name (eg., "ABS_X"). The prefix must be included in
  ##    the name. It returns the constant assigned to the event code or -1 if not
  ##    found.
  ##   
  ##    You have to pass the event type where to look for the name. For instance, to
  ##    resolve "ABS_X" you need to pass EV_ABS as type and "ABS_X" as string.
  ##    Supported event codes are codes starting with SYN_, KEY_, BTN_, REL_, ABS_,
  ##    MSC_, SND_, SW_, LED_, REP_, FF_.
  ##   
  ##    @param type The event type (EV_* constant) where to look for the name.
  ##    @param name A non-NULL string describing an input-event code ("KEY_A",
  ##    "ABS_X", "BTN_Y", ...).
  ##    @param len The length of the string in @p name excluding any terminating 0
  ##    character.
  ##   
  ##    @return The given code constant for the name or -1 if not found.
  ## ```
proc libevdev_event_value_from_name*(`type`: cuint; code: cuint; name: cstring): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event value by its type, code and name. Event values start
  ##    with a fixed prefix followed by their name (eg., "MT_TOOL_PALM"). The
  ##    prefix must be included in the name. It returns the constant assigned
  ##    to the event code or -1 if not found.
  ##   
  ##    You have to pass the event type and code where to look for the name. For
  ##    instance, to resolve "MT_TOOL_PALM" you need to pass EV_ABS as type,
  ##    ABS_MT_TOOL_TYPE as code and "MT_TOOL_PALM" as string.
  ##   
  ##    As of kernel 4.17, only EV_ABS/ABS_MT_TOOL_TYPE support name resolution.
  ##   
  ##    @param type The event type (EV_* constant) where to look for the name.
  ##    @param code The event code (ABS_* constant) where to look for the name.
  ##    @param name A non-NULL string describing an input-event value
  ##    ("MT_TOOL_TYPE", ...)
  ##   
  ##    @return The given value constant for the name or -1 if not found.
  ## ```
proc libevdev_event_type_from_code_name*(name: cstring): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event type for a  event code name. For example, the name
  ##    "ABS_Y" returns EV_ABS. For the lookup to succeed, the name must be
  ##    unique, which is the case for all defines as of kernel 5.0 and likely to
  ##    be the case in the future.
  ##   
  ##    This is equivalent to libevdev_event_type_from_name() but takes the code
  ##    name instead of the type name.
  ##   
  ##    @param name A non-NULL string describing an input-event value
  ##    ("ABS_X", "REL_Y", "KEY_A", ...)
  ##   
  ##    @return The given event code for the name or -1 if not found.
  ## ```
proc libevdev_event_type_from_code_name_n*(name: cstring; len: uint): cint {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event type for a  event code name. For example, the name
  ##    "ABS_Y" returns EV_ABS. For the lookup to succeed, the name must be
  ##    unique, which is the case for all defines as of kernel 5.0 and likely to
  ##    be the case in the future.
  ##   
  ##    This is equivalent to libevdev_event_type_from_name_n() but takes the code
  ##    name instead of the type name.
  ##   
  ##    @param name A non-NULL string describing an input-event value
  ##    ("ABS_X", "REL_Y", "KEY_A", ...)
  ##    @param len The length of the passed string excluding any terminating 0
  ##    character.
  ##   
  ##    @return The given event code for the name or -1 if not found.
  ## ```
proc libevdev_event_code_from_code_name*(name: cstring): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event code by its name. For example, the name "ABS_Y"
  ##    returns 1. For the lookup to succeed, the name must be unique, which is
  ##    the case for all defines as of kernel 5.0 and likely to be the case in
  ##    the future.
  ##   
  ##    This is equivalent to libevdev_event_code_from_name() without the need
  ##    for knowing the event type.
  ##   
  ##    @param name A non-NULL string describing an input-event value
  ##    ("ABS_X", "REL_Y", "KEY_A", ...)
  ##   
  ##    @return The given event code for the name or -1 if not found.
  ## ```
proc libevdev_event_code_from_code_name_n*(name: cstring; len: uint): cint {.importc,
    cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event code by its name. For example, the name "ABS_Y"
  ##    returns 1. For the lookup to succeed, the name must be unique, which is
  ##    the case for all defines as of kernel 5.0 and likely to be the case in
  ##    the future.
  ##   
  ##    This is equivalent to libevdev_event_code_from_name_n() without the need
  ##    for knowing the event type.
  ##   
  ##    @param name A non-NULL string describing an input-event value
  ##    ("ABS_X", "REL_Y", "KEY_A", ...)
  ##    @param len The length of the passed string excluding any terminating 0
  ##    character.
  ##   
  ##    @return The given event code for the name or -1 if not found.
  ## ```
proc libevdev_event_value_from_name_n*(`type`: cuint; code: cuint; name: cstring;
                                      len: uint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an event value by its type, code and name. Event values start
  ##    with a fixed prefix followed by their name (eg., "MT_TOOL_PALM"). The
  ##    prefix must be included in the name. It returns the constant assigned
  ##    to the event code or -1 if not found.
  ##   
  ##    You have to pass the event type and code where to look for the name. For
  ##    instance, to resolve "MT_TOOL_PALM" you need to pass EV_ABS as type,
  ##    ABS_MT_TOOL_TYPE as code and "MT_TOOL_PALM" as string.
  ##   
  ##    As of kernel 4.17, only EV_ABS/ABS_MT_TOOL_TYPE support name resolution.
  ##   
  ##    @param type The event type (EV_* constant) where to look for the name.
  ##    @param code The event code (ABS_* constant) where to look for the name.
  ##    @param name A non-NULL string describing an input-event value
  ##    ("MT_TOOL_TYPE", ...)
  ##    @param len The length of the string in @p name excluding any terminating 0
  ##    character.
  ##   
  ##    @return The given value constant for the name or -1 if not found.
  ## ```
proc libevdev_property_from_name*(name: cstring): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an input property by its name. Properties start with the fixed
  ##    prefix "INPUT_PROP_" followed by their name (eg., "INPUT_PROP_POINTER").
  ##    The prefix must be included in the name. It returns the constant assigned
  ##    to the property or -1 if not found.
  ##   
  ##    @param name A non-NULL string describing an input property
  ##   
  ##    @return The given code constant for the name or -1 if not found.
  ## ```
proc libevdev_property_from_name_n*(name: cstring; len: uint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup misc
  ##   
  ##    Look up an input property by its name. Properties start with the fixed
  ##    prefix "INPUT_PROP_" followed by their name (eg., "INPUT_PROP_POINTER").
  ##    The prefix must be included in the name. It returns the constant assigned
  ##    to the property or -1 if not found.
  ##   
  ##    @param name A non-NULL string describing an input property
  ##    @param len The length of the string in @p name excluding any terminating 0
  ##    character.
  ##   
  ##    @return The given code constant for the name or -1 if not found.
  ## ```
proc libevdev_get_repeat*(dev: ptr libevdev; delay: ptr cint; period: ptr cint): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup bits
  ##   
  ##    Get the repeat delay and repeat period values for this device. This
  ##    function is a convenience function only, EV_REP is supported by
  ##    libevdev_get_event_value().
  ##   
  ##    @param dev The evdev device, already initialized with libevdev_set_fd()
  ##    @param delay If not null, set to the repeat delay value
  ##    @param period If not null, set to the repeat period value
  ##   
  ##    @return 0 on success, -1 if this device does not have repeat settings.
  ##   
  ##    @note This function is signal-safe
  ##   
  ##    @see libevdev_get_event_value
  ## ```
proc libevdev_uinput_create_from_device*(dev: ptr libevdev; uinput_fd: cint;
                                        uinput_dev: ptr ptr libevdev_uinput): cint {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup uinput
  ##   
  ##    Create a uinput device based on the given libevdev device. The uinput device
  ##    will be an exact copy of the libevdev device, minus the bits that uinput doesn't
  ##    allow to be set.
  ##   
  ##    If uinput_fd is @ref LIBEVDEV_UINPUT_OPEN_MANAGED, libevdev_uinput_create_from_device()
  ##    will open @c /dev/uinput in read/write mode and manage the file descriptor.
  ##    Otherwise, uinput_fd must be opened by the caller and opened with the
  ##    appropriate permissions.
  ##   
  ##    The device's lifetime is tied to the uinput file descriptor, closing it will
  ##    destroy the uinput device. You should call libevdev_uinput_destroy() before
  ##    closing the file descriptor to free allocated resources.
  ##    A file descriptor can only create one uinput device at a time; the second device
  ##    will fail with -EINVAL.
  ##   
  ##    You don't need to keep the file descriptor variable around,
  ##    libevdev_uinput_get_fd() will return it when needed.
  ##   
  ##    @note Due to limitations in the uinput kernel module, REP_DELAY and
  ##    REP_PERIOD will default to the kernel defaults, not to the ones set in the
  ##    source device.
  ##   
  ##    @param dev The device to duplicate
  ##    @param uinput_fd @ref LIBEVDEV_UINPUT_OPEN_MANAGED or a file descriptor to @c /dev/uinput,
  ##    @param[out] uinput_dev The newly created libevdev device.
  ##   
  ##    @return 0 on success or a negative errno on failure. On failure, the value of
  ##    uinput_dev is unmodified.
  ##   
  ##    @see libevdev_uinput_destroy
  ## ```
proc libevdev_uinput_destroy*(uinput_dev: ptr libevdev_uinput) {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup uinput
  ##   
  ##    Destroy a previously created uinput device and free associated memory.
  ##   
  ##    If the device was opened with @ref LIBEVDEV_UINPUT_OPEN_MANAGED,
  ##    libevdev_uinput_destroy() also closes the file descriptor. Otherwise, the
  ##    fd is left as-is and must be closed by the caller.
  ##   
  ##    @param uinput_dev A previously created uinput device.
  ## ```
proc libevdev_uinput_get_fd*(uinput_dev: ptr libevdev_uinput): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup uinput
  ##   
  ##    Return the file descriptor used to create this uinput device. This is the
  ##    fd pointing to <strong>/dev/uinput</strong>. This file descriptor may be used to write
  ##    events that are emitted by the uinput device.
  ##    Closing this file descriptor will destroy the uinput device, you should
  ##    call libevdev_uinput_destroy() first to free allocated resources.
  ##   
  ##    @param uinput_dev A previously created uinput device.
  ##   
  ##    @return The file descriptor used to create this device
  ## ```
proc libevdev_uinput_get_syspath*(uinput_dev: ptr libevdev_uinput): cstring {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup uinput
  ##   
  ##    Return the syspath representing this uinput device. If the UI_GET_SYSNAME
  ##    ioctl not available, libevdev makes an educated guess.
  ##    The UI_GET_SYSNAME ioctl is available since Linux 3.15.
  ##   
  ##    The syspath returned is the one of the input node itself
  ##    (e.g. /sys/devices/virtual/input/input123), not the syspath of the device
  ##    node returned with libevdev_uinput_get_devnode().
  ##   
  ##    @note This function may return NULL if UI_GET_SYSNAME is not available.
  ##    In that case, libevdev uses ctime and the device name to guess devices.
  ##    To avoid false positives, wait at least wait at least 1.5s between
  ##    creating devices that have the same name.
  ##   
  ##    @param uinput_dev A previously created uinput device.
  ##    @return The syspath for this device, including the preceding /sys
  ##   
  ##    @see libevdev_uinput_get_devnode
  ## ```
proc libevdev_uinput_get_devnode*(uinput_dev: ptr libevdev_uinput): cstring {.
    importc, cdecl, implibevdevuinputDyn.}
  ## ```
  ##   @ingroup uinput
  ##   
  ##    Return the device node representing this uinput device.
  ##   
  ##    This relies on libevdev_uinput_get_syspath() to provide a valid syspath.
  ##    See libevdev_uinput_get_syspath() for more details.
  ##   
  ##    @note This function may return NULL. libevdev may have to guess the
  ##    syspath and the device node. See libevdev_uinput_get_syspath() for details.
  ##    @param uinput_dev A previously created uinput device.
  ##    @return The device node for this device, in the form of /dev/input/eventN
  ##   
  ##    @see libevdev_uinput_get_syspath
  ## ```
proc libevdev_uinput_write_event*(uinput_dev: ptr libevdev_uinput; `type`: cuint;
                                 code: cuint; value: cint): cint {.importc, cdecl,
    implibevdevuinputDyn.}
  ## ```
  ##   @ingroup uinput
  ##   
  ##    Post an event through the uinput device. It is the caller's responsibility
  ##    that any event sequence is terminated with an EV_SYN/SYN_REPORT/0 event.
  ##    Otherwise, listeners on the device node will not see the events until the
  ##    next EV_SYN event is posted.
  ##   
  ##    @param uinput_dev A previously created uinput device.
  ##    @param type Event type (EV_ABS, EV_REL, etc.)
  ##    @param code Event code (ABS_X, REL_Y, etc.)
  ##    @param value The event value
  ##    @return 0 on success or a negative errno on error
  ## ```
{.pop.}
