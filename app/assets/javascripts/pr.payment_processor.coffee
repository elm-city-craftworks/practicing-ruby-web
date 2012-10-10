class PR.PaymentProcessor
  constructor: (@key) ->
    Stripe.setPublishableKey @key
    @form = $("#payment-form");
    @form.submit this.formSubmit

    $('a#show-cvc-help').click (e) ->
      $.facebox { div: '#cvc-help' }, 'cvc-help'
      e.preventDefault()

  formSubmit: (event) =>
    # disable the submit button to prevent repeated clicks
    $('.submit-button').attr "disabled", "disabled"
    $(".payment-errors").text ""

    target  = document.getElementById('processing-spinner')

    spinnerOpts = {
      lines: 9,
      length: 4,
      width: 3,
      radius: 5,
      corners: 0.8,
      hwaccel: true,
      speed: 1.6
    };

    @spinner = new Spinner(spinnerOpts).spin(target)

    Stripe.createToken {
        number:    $('.card-number').val(),
        cvc:       $('.card-cvc').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year:  $('.card-expiry-year').val()
    }, this.responseHandler

    # prevent the form from submitting with the default action
    event.preventDefault();
  responseHandler: (status, response) =>
    if (response.error)
      @spinner.stop()
      $(".payment-errors").text      response.error.message
      $(".submit-button").removeAttr "disabled"
    else
      # token contains id, last4, and card type
      token = response['id']
      # insert the token into the form so it gets submitted to the server
      @form.append "<input type='hidden' name='stripeToken' value='#{token}'/>"
      # and submit
      @form.get(0).submit()
