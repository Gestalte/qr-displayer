#lang racket
 
(require simple-qr)
(require racket/gui)

; TODO: Figure out how to make the horzontal panel stick to the top.
(define frame (new frame%
                   [label "QR Displayer"]
                   [width 500]
                   [height 500]
                   [stretchable-width #f]	 
                   [stretchable-height #f]))

(define v-panel (new vertical-panel%
                     [parent frame]
                     [alignment '(left top)]))

(define h-panel (new horizontal-panel%
                     [parent v-panel]
                     [alignment '(left top)]))

(define text-field (new text-field%
                        (label "QR Text")
                        (parent h-panel)
                        (init-value "")))

(define image-path (build-path (current-directory) "qrcode.png"))

(void (new button%
           [parent h-panel]
           [label "Load"]
           [callback (lambda (button event)
                       (define input-text (send text-field get-value))
                       (qr-write input-text image-path)
                       (send qr-image refresh-now)
                       (send qr-image on-paint)
                       )]))

(define qr-image (new canvas%
                      (parent v-panel)
                      [min-width 500]
                      [min-height 500]
                      [paint-callback (lambda (canvas dc)
                                        (cond
                                          [(file-exists? image-path)
                                           (send dc draw-bitmap (read-bitmap image-path) 0 0)
                                           (delete-file image-path)]))]))

(send frame show #t)