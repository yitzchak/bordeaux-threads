#|
Copyright 2006,2007 Greg Pfeil

Distributed under the MIT license (see LICENSE file)
|#

(in-package #:bordeaux-threads)

;;; the implementation of the Armed Bear thread interface can be found in
;;; src/org/armedbearlisp/LispThread.java

;;; Thread Creation

(defun make-thread (function &key name)
  (ext:make-thread function :name name))

(defmethod current-thread ()
  (ext:current-thread))

(defmethod thread-name (thread)
  (ext:thread-name thread))

;;; Yes, this is nasty
(defmethod threadp (object)
  (handler-case (progn (thread-name object) t)
    (type-error () nil)))

;;; Resource contention: locks and recursive locks

;;; Don't know what the arguments to MAKE-THREAD-LOCK are, but it
;;; doesn't mind being a thunk
(defun make-lock (&optional name)
  (declare (ignore name))
  (ext:make-thread-lock))

(defmethod acquire-lock (lock &optional (wait-p t))
  (ext:thread-lock lock))

(defmethod release-lock (lock)
  (ext:thread-unlock lock))

(defmacro with-lock-held ((place) &body body)
  `(ext:with-thread-lock (,place) ,@body))

;;; Resource contention: condition variables

(defun thread-yield ()
  (sleep 0))

;;; Introspection/debugging

(defmethod interrupt-thread (thread function)
  (ext:interrupt-thread thread function))

(defmethod destroy-thread (thread)
  (ext:destroy-thread thread))

(defmethod thread-alive-p (thread)
  (ext:thread-alive-p thread))

(mark-supported)
