class PR.PaymentProcessor
  constructor: (@key) ->
    Stripe.setPublishableKey @key
    @form = $("#payment-form");
    @form.submit this.formSubmit
  formSubmit: (event) =>
    # disable the submit button to prevent repeated clicks
    $('.submit-button').attr "disabled", "disabled"

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
      $(".payment-errors").text      response.error.message
      $(".submit-button").removeAttr "disabled"
    else
      # token contains id, last4, and card type
      token = response['id']
      # insert the token into the form so it gets submitted to the server
      @form.append "<input type='hidden' name='stripeToken' value='#{token}'/>"
      # and submit
      @form.get(0).submit()
