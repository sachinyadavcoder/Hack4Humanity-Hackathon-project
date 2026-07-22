import nodemailer from 'nodemailer'

let transporter = null

function getTransporter() {
  if (transporter) return transporter

  transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST || 'smtp.gmail.com',
    port: Number(process.env.EMAIL_PORT) || 465,
    secure: true, // true for port 465
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_APP_PASSWORD, // Gmail App Password, not the account password
    },
  })

  return transporter
}

export async function sendOtpEmail(toEmail, otp, doctorName = 'Doctor') {
  const mailOptions = {
    from: process.env.EMAIL_FROM || process.env.EMAIL_USER,
    to: toEmail,
    subject: 'Your MAAAi verification code',
    text: `Hello ${doctorName},\n\nYour MAAAi verification code is ${otp}. It expires in 5 minutes.\n\nIf you did not request this, you can safely ignore this email.`,
    html: `
      <div style="font-family: sans-serif; max-width: 480px; margin: 0 auto;">
        <h2 style="color: #0F5C5C;">MAAAi Doctor Verification</h2>
        <p>Hello ${doctorName},</p>
        <p>Your verification code is:</p>
        <p style="font-size: 28px; font-weight: bold; letter-spacing: 6px; color: #0F5C5C;">${otp}</p>
        <p>This code expires in 5 minutes. If you did not request this, you can safely ignore this email.</p>
      </div>
    `,
  }

  await getTransporter().sendMail(mailOptions)
}

export default { sendOtpEmail }
