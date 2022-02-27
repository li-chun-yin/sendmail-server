<?php
namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Mime\Email;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mailer\Transport;
use Symfony\Component\Mailer\Transport\Dsn;


/**
 * 
 * @author 李春寅 <http://licy.top>
 */
class SendController extends AbstractController
{
    /**
     * @Route("/send/content")
     * @param Request $request
     * @return Response
     */
    public function content(Request $request) : Response
    {
        $email      = $request->get('email');
        $subject    = $request->get('subject');
        $content    = $request->get('content');
                
        $message  = (new Email())
        ->from($this->getParameter('app.mailer_user'))
        ->to($email)
        ->subject($subject)
        ->text($content);
        
        $transport = (new Transport(Transport::getDefaultFactories()))->fromDsnObject(new Dsn(
            $this->getParameter('app.mailer_scheme'),
            $this->getParameter('app.mailer_host'),
            $this->getParameter('app.mailer_user'),
            $this->getParameter('app.mailer_password'),
            $this->getParameter('app.mailer_port')
        ));
        
        $mailer = new Mailer($transport);
        $mailer->send($message);
        
        
        return $this->json('success');
    }
}